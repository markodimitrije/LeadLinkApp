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
    private var questions: [PresentQuestion]
    
    init(scrollView: QuestionsScrollView, questions: [PresentQuestion]) {
        self.scrollView = scrollView
        self.questions = questions
    }
    
    func scrollTo(question: PresentQuestion) {
        
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
        return !isVisible(view: view)
    }
}

func isVisible(view: UIView) -> Bool {
    func isVisible(view: UIView, inView: UIView?) -> Bool {
        guard let inView = inView else { return true }
        let viewFrame = inView.convert(view.bounds, from: view)
        if viewFrame.intersects(inView.bounds) {
            return isVisible(view: view, inView: inView.superview)
        }
        return false
    }
    return isVisible(view: view, inView: view.superview)
}

//extension UIView {
//    func isVisible() -> Bool {
//        func isVisible(view: UIView, inView: UIView?) -> Bool {
//            guard let inView = inView else { return true }
//            let viewFrame = inView.convert(view.bounds, from: view)
//            if viewFrame.intersects(inView.bounds) {
//                return isVisible(view: view, inView: inView.superview)
//            }
//            return false
//        }
//        return isVisible(view: self, inView: self.superview)
//    }
//}
