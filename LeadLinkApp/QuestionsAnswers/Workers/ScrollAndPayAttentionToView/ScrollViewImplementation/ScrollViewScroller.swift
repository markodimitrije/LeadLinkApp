//
//  ScrollViewScroller.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ScrollViewScroller: ScrollingToField {
    
    private var scrollView: QuestionsScrollView
    
    init(scrollView: QuestionsScrollView) {
        self.scrollView = scrollView
    }
    
    func scrollTo(question: QuestionProtocol) {
        
        guard let viewToScrollTo = scrollView.getQuestionView(question: question) else {
            return
        }
        
        if shouldScroll(view: viewToScrollTo) {
            let destinationPoint = scrollView.convert(viewToScrollTo.frame.origin, to: scrollView)
            self.scrollView.contentOffset = destinationPoint
        } else {
            print("ne treba da scroll.....")
        }
        
    }
    
    private func shouldScroll(view: UIView) -> Bool {
        return !view.isVisible()
    }
}
