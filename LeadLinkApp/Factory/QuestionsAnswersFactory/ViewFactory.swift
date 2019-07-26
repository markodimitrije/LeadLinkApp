//
//  ViewFactory.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewFactory {
    
    var bounds: CGRect
    var allowableWidth: CGFloat!
    
    init(bounds: CGRect) { // treba da je sa Questions...
        self.bounds = bounds
        loadViewsWidth()
    }
    
    private func loadViewsWidth() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.allowableWidth = (UIApplication.topViewController()?.view.frame.width ?? UIScreen.main.bounds.width) * 0.6
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            self.allowableWidth = UIApplication.topViewController()?.view.frame.width ?? UIScreen.main.bounds.width
        }
    }
    
    func getStackedRadioBtns(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        return createStackWithSameComponents(ofType: RadioBtnView.self, componentsTotalCount: question.options.count, inOneRow: 1)!
        
    }
    
    func getStackedCheckboxBtns(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: CheckboxView.self, count: question.options.count, inOneRow: 3)!
        return createStackWithSameComponents(ofType: CheckboxView.self, componentsTotalCount: question.options.count, inOneRow: 1)!
        
    }
    
    func getStackedRadioBtnsWithInput(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        //let stacker = produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        let stacker = createStackWithSameComponents(ofType: RadioBtnView.self, componentsTotalCount: question.options.count, inOneRow: 1)!
        
        guard let lastRow = stacker.components.last as? OneRowStacker,
            let lastElement = lastRow.components.last else {  return stacker }
        
        let txtBox = UITextField.init(frame: lastElement.bounds)
        txtBox.backgroundColor = .gray
        
        if lastRow.components.count == 3 { // max per row !
            guard let newRow = OneRowStacker.init(frame: lastRow.bounds, components: [txtBox]) else {return stacker}
            stacker.addAsLast(view: newRow)
        } else {
            lastRow.insertAsLast(view: txtBox) // dodaj ga na view
        }
        
        return stacker
        
    }
    
    func getStackedCheckboxBtnsWithInput(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        //let stacker = produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        let stacker = createStackWithSameComponents(ofType: CheckboxView.self, componentsTotalCount: question.options.count, inOneRow: 1)!
        
        guard let lastRow = stacker.components.last as? OneRowStacker,
            let lastElement = lastRow.components.last else {  return stacker }
        
        let txtBox = UITextField.init(frame: lastElement.bounds)
        txtBox.backgroundColor = .gray
        
        if lastRow.components.count == 3 { // max per row !
            guard let newRow = OneRowStacker.init(frame: lastRow.bounds, components: [txtBox]) else {return stacker}
            stacker.addAsLast(view: newRow)
        } else {
            lastRow.insertAsLast(view: txtBox) // dodaj ga na view
        }
        
        return stacker
        
    }
    
    func getStackedSwitchBtns(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        return createStackWithSameComponents(ofType: LabelBtnSwitchView.self,
                                             componentsTotalCount: question.options.count,
                                             inOneRow: 1)!
        
    }
    
    func getTermsSwitchBtn(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        return createStackWithSameComponents(ofType: TermsLabelBtnSwitchView.self,
                                             componentsTotalCount: 1,
                                             inOneRow: 1)!
    }
    
    func getStackedLblAndTextField(questionWithAnswers: [(PresentQuestion, Answering?)], frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        return createStackWithSameComponents(ofType: LabelAndTextField.self,
                                             //componentsTotalCount: questionWithAnswers.count,
                                            //componentsTotalCount: 2,
                                             //inOneRow: 2)!
                                            componentsTotalCount: 1,
                                            inOneRow: 1)!
    }
    
    func getStackedLblAndTextView(questionWithAnswers: [(PresentQuestion, Answering?)], frame: CGRect) -> ViewStacker {
        
        //var contentHeight = CGFloat.init(80)
        var contentHeight = frame.height
        
        let contentCounts = questionWithAnswers.map {$0.1?.content.count ?? 0}
        let maxContentCount = contentCounts.sorted(by: >).first
        
        if let maxContentCount = maxContentCount, maxContentCount > 1 {
            contentHeight = CGFloat(maxContentCount * 22) // sta je ovo ??!?!? hard-coded ??
        }
        
        let viewStacker = createStackWithSameComponents(ofType: LabelAndTextView.self, componentsTotalCount: questionWithAnswers.count, inOneRow: 1)!
        viewStacker.frame.size.height = contentHeight
        
        return viewStacker
        
    }
    
    private func createStackWithSameComponents(ofType type: UIView.Type, componentsTotalCount: Int, inOneRow: Int) -> ViewStacker? {
        
        guard inOneRow <= 3 else {return nil}
        
        var numOfRows = componentsTotalCount / inOneRow
        var isOdd = false
        let residue = componentsTotalCount % inOneRow
        
        if residue != 0 {
            numOfRows += 1
            isOdd = true
        }
        
        var components = [OneRowStacker]()
        
        for index in 1...numOfRows {
            if index == numOfRows && isOdd {
                components.append(produceOneRowInVerticalStack(ofType: type, inOneRow: residue))
            } else {
                components.append(produceOneRowInVerticalStack(ofType: type, inOneRow: inOneRow))
            }
            
        }
        
        let frame = getRect(forComponents: components)
        let stack = ViewStacker.init(frame: frame, components: components)
//        print("stack.bounds = \(stack.bounds)")
        return stack
        
    }
    
    // calculate... sigurno nije na VC-u ....
    
    func getRect(forComponents components: [UIView]) -> CGRect {
        
        let height = getHeight(forComponents: components)
        
        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: allowableWidth,
                                                                   height: height))
    }
    
    
    
    
    private func getHeight(forComponents components: [UIView]) -> CGFloat {
        var height = CGFloat.init(0)
        for c in components {
            height += c.bounds.height + CGFloat.init(8)
        }
        return height
    }
    
    
    
    private func getHeight(forComponents components: [UIView], inOneRow: Int) -> CGFloat {
        var height = CGFloat.init(0)
        guard let first = components.first else {return 0.0}
        for _ in 1...getNumberOfRows(components: components, inOneRow: inOneRow) {
            height += first.bounds.height + CGFloat.init(8)
        }
        return height
    }
    
    
    private func getNumberOfRows(components: [UIView], inOneRow: Int) -> Int {
        
        var numOfRows = components.count / inOneRow
        
        if components.count % inOneRow != 0 {
            numOfRows += 1
        }
        
        return numOfRows
    }
    
    private func produceOneRowInVerticalStack(ofType type: UIView.Type, inOneRow: Int) -> OneRowStacker {
        
        var compType = QuestionType.textField
        if type is RadioBtnView.Type {
            compType = .radioBtn
        } else if type is CheckboxView.Type {
            compType = .checkbox
        } else if type is LabelBtnSwitchView.Type {
            compType = .switchBtn
        } else if type is TermsLabelBtnSwitchView.Type {
            compType = .termsSwitchBtn
        } else if type is LabelAndTextField.Type {
            compType = .textField
        }
        
        let rowHeight = tableRowHeightCalculator.getOneRowHeight(componentType: compType)
        
        var components = [UIView]()
        for _ in 1...inOneRow {
            let v = type.init()
            components.append(v)
        }
        let row = stackElementsInOneRow(components: components, rowHeight: rowHeight)
        return row
        
    }
    
//    func getRect(forComponents components: [UIView], inOneRow: Int) -> CGRect {
//
//        let height = getHeight(forComponents: components, inOneRow: inOneRow)
//
//        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: bounds.width, height: height))
//    }
//
//    func stackElementsInOneRow(components: [UIView], rowHeight: CGFloat) -> OneRowStacker {
//
//        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: bounds.width, height: rowHeight))
//        return OneRowStacker.init(frame: rect, components: components)!
//
//    }
    
    func getRect(forComponents components: [UIView], inOneRow: Int) -> CGRect {
        
        let height = getHeight(forComponents: components, inOneRow: inOneRow)
        
        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: allowableWidth,
                                                                   height: height))
    }
    
    func stackElementsInOneRow(components: [UIView], rowHeight: CGFloat) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: allowableWidth,
                                                                       height: rowHeight))
        return OneRowStacker.init(frame: rect, components: components)!
        
    }
    
}
