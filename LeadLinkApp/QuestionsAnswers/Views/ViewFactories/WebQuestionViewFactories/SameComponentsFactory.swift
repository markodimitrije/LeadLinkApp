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

class SameComponentsFactory {
    
    var allowableWidth: CGFloat
    
    init(questionsWidthProvider: QuestionsAnswersTableWidthCalculating) {
        self.allowableWidth = questionsWidthProvider.getWidth()
    }
    
    func createStackWithSameComponents(ofType type: UIView.Type, componentsTotalCount: Int, elementsInOneRow: Int) -> ViewStacker? {
        
        guard elementsInOneRow <= 3 else {return nil}
        
        var numOfRows = componentsTotalCount / elementsInOneRow
        var isOdd = false
        let residue = componentsTotalCount % elementsInOneRow
        
        if residue != 0 {
            numOfRows += 1
            isOdd = true
        }
        
        var components = [OneRowStacker]()
        
        for index in 1...numOfRows {
            if index == numOfRows && isOdd {
                components.append(produceOneRowInVerticalStack(ofType: type, elementsInOneRow: residue))
            } else {
                components.append(produceOneRowInVerticalStack(ofType: type, elementsInOneRow: elementsInOneRow))
            }
            
        }
        
        let frame = getRect(forComponents: components)
        let stack = ViewStacker.init(frame: frame, components: components)
        //        print("stack.bounds = \(stack.bounds)")
        return stack
        
    }
    
    private func produceOneRowInVerticalStack(ofType type: UIView.Type, elementsInOneRow: Int) -> OneRowStacker {
        
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
        for _ in 1...elementsInOneRow {
            let v = type.init()
            components.append(v)
        }
        let row = stackElementsInOneRow(components: components, rowHeight: rowHeight)
        return row
        
    }
    
    private func getRect(forComponents components: [UIView]) -> CGRect {
        
        let height = getHeight(forComponents: components)
        
        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: allowableWidth,
                                                                   height: height))
    }
    
    private func stackElementsInOneRow(components: [UIView], rowHeight: CGFloat) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: allowableWidth,
                                                                       height: rowHeight))
        return OneRowStacker.init(frame: rect, components: components)!
        
    }
    
    private func getHeight(forComponents components: [UIView]) -> CGFloat {
        var height = CGFloat.init(0)
        for c in components {
            height += c.bounds.height + CGFloat.init(8)
        }
        return height
    }
}
