# 
# This file is part of the Scandit Data Capture SDK
# 
# Copyright (C) 2017- Scandit AG. All rights reserved.
# 

function message {
    echo "strip-frameworks.sh: $1"
}

function strip_architectures {
    binary="$1"
    archs="$(lipo -info "${binary}" | rev | cut -d ':' -f1 | rev)"
    stripped_archs=""
    for arch in $archs; do
        if [[ "$VALID_ARCHS" != *"$arch"* ]]; then
            lipo -remove "$arch" -output "$binary" "$binary" || exit 1
            stripped_archs="$stripped_archs $arch"
        fi
    done
    echo "$stripped_archs"
}

function code_sign_binary() {
    message "Code signing $1 with identity \"${EXPANDED_CODE_SIGN_IDENTITY_NAME}\""
    /usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" --preserve-metadata=identifier,entitlements "$1"
}

message "Stripping Scandit frameworks"

cd "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH" || exit 1

frameworks=("ScanditCaptureCore" "ScanditBarcodeCapture" "ScanditLabelCapture")

for framework in "${frameworks[@]}"; do
    framework_folder="$framework.framework"
    framework_binary="$framework_folder/$framework"

    if ! [ -d "$framework_folder" ]; then
        continue
    fi

    # Remove strip-frameworks script if archiving
    if [ "$ACTION" = "install" ]; then
        if [ -e "$framework_folder/strip-frameworks.sh" ]; then
            rm -f "$framework_folder/strip-frameworks.sh"
            message "Removed strip-frameworks.sh from embedded $framework_folder"
        fi
    fi

    # It's important to copy/remove the bcsymbolmap files before code signing, to avoid code signing issues.
    if [ "$ACTION" = "install" ]; then
        find . -name '*.bcsymbolmap' -type f -exec mv {} "${CONFIGURATION_BUILD_DIR}" \;
        message "Copied .bcsymbolmap files to .xcarchive"
    else
        # Delete *.bcsymbolmap files from framework bundle unless archiving
        find . -name '*.bcsymbolmap' -type f -exec rm -rf "{}" +\;
    fi

    # Strip architectures.
    stripped_archs=$(strip_architectures "$framework_binary")

    if [[ "$stripped_archs" != "" ]]; then
        message "Stripped $framework of architectures: $stripped_archs"
        if [ "${CODE_SIGNING_REQUIRED}" == "YES" ]; then
            # Sign binary again.
            code_sign_binary "${framework_binary}"
        fi
    fi
done
