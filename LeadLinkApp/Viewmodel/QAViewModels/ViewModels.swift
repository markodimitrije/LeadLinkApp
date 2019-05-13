//
//  ViewModels.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RadioViewModel: NSObject, ViewModelType, Questanable {
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    //init(question: PresentQuestion, answer: RadioAnswer?) {
    init(question: PresentQuestion, answer: MyAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<Int>
        //var answer: RadioAnswer?
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<Int> // tap koji mapiras u id (btn.tag)
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resulting = (answer == nil) ? input.ids : Observable.merge(Observable.of(answer!.optionIds!.last!), input.ids)
        
        let output = Output.init(ids: resulting)
        
        return output
    }
    
    private var bag = DisposeBag()
}

class CheckboxViewModel: NSObject, ViewModelType, Questanable {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    init(question: PresentQuestion, answer: MyAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<[Int]>
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<[Int]> // tap koji mapiras u id (btn.tag)
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resulting = Observable.merge(Observable.of(answer?.optionIds ?? [ ]), input.ids)
        
        let withAnswer = (answer != nil) ? resulting : input.ids
        
        let output = Output.init(ids: withAnswer)
        
        return output
    }
    
    let bag = DisposeBag()

}
    
class RadioWithInputViewModel: NSObject, ViewModelType, Questanable {
    
    var question: PresentQuestion
    var answer: MyAnswer? //{
//        didSet {
//            print("RadioWithInputViewModel.answer is set to = \(String(describing: answer))")
//        }
    //}
    var code: String = ""
    
    //init(question: PresentQuestion, answer: RadioAnswer?) {
    init(question: PresentQuestion, answer: MyAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var id: Observable<Int>
        var optionTxt: Observable<String?>
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var id: Observable<Int> // tap koji mapiras u id (btn.tag)
        var optionTxt: Observable<String?>
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let output = Output.init(id: input.id, optionTxt: input.optionTxt)
        
        return output
    }
    
    private var bag = DisposeBag()
}

class CheckboxWithInputViewModel: NSObject, ViewModelType, Questanable {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    init(question: PresentQuestion, answer: MyAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<Int>
        var optionTxt: Observable<String?>
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<Int> // tap koji mapiras u id (btn.tag)
        var optionTxt: Observable<String?>
    }
    
    func transform(input: Input) -> Output {
        
        let resultingBtns = (answer == nil) ? input.ids : input.ids
        
        let output = Output.init(ids: resultingBtns, optionTxt: input.optionTxt)
        
        return output
    }
    
    private var bag = DisposeBag()
}

class SwitchBtnsViewModel: NSObject, ViewModelType, Questanable {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    init(question: PresentQuestion, answer: MyAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<[Int]>
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<[Int]> // tap koji mapiras u id (btn.tag)
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resulting = Observable.merge(Observable.of(answer?.optionIds ?? [ ]), input.ids)
        
        let withAnswer = (answer == nil) ? input.ids : resulting
        
        let output = Output.init(ids: withAnswer)
        
        return output
    }
    
    private var bag = DisposeBag()
    
}

class LabelWithTextFieldViewModel: NSObject, ViewModelType, Questanable {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    init(question: PresentQuestion, answer: MyAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var content: Observable<[String]> // ovo su izabrane opcije, npr ["ita", "bra", "usa"...]
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var content: Observable<[String]> // txt koji mapiras
    }
    
    func transform(input: Input) -> Output {
        
        let withAnswer = Observable.merge(Observable.of(answer?.content ?? [ ]), input.content)
        
        //print("withAnswer = \(withAnswer)")
        
        return Output.init(content: withAnswer)
    }
    
    private var bag = DisposeBag()
    
}

class SelectOptionTextFieldViewModel: NSObject, ViewModelType, Questanable {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    init(question: PresentQuestion, answer: MyAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var content: Observable<[String]> // ovo su izabrane opcije, npr ["ita", "bra", "usa"...]
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var content: Observable<[String]> // txt koji mapiras
    }
    
    func transform(input: Input) -> Output {
        
        let withAnswer = Observable.merge(Observable.of(answer?.content ?? [ ]), input.content)
        
        return Output.init(content: withAnswer)
    }
    
    private var bag = DisposeBag()
    
}
