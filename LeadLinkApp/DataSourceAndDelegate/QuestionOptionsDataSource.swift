//
//  QuestionOptionsDataSource.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 09/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QuestionOptionsTableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    lazy var observableAnswer = BehaviorRelay.init(value: answer)
    var observableSearch: ControlProperty<String?>! {
        didSet {
            observableSearch.subscribe(onNext: { (value) in
                if value == "" {
                    self.options.accept(self.question.options)
                } else {
                    let contained = self.question.options.filter({ option -> Bool in
                        return NSString.init(string: option).contains(value ?? "")
                    })
                    self.options.accept(contained)
                }
                self.tableView.reloadData()
            }).disposed(by: bag)
        }
    }
    
    var question: PresentQuestion
    var tableView: UITableView!
    
    private var options = BehaviorRelay<[String]>(value: [])
    private var answer: MyAnswer?
    
    init(selectOptionTextViewModel: SelectOptionTextFieldViewModel) {
        self.question = selectOptionTextViewModel.question
        self.answer = selectOptionTextViewModel.answer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        let text = options.value[indexPath.row]
        cell.textLabel?.text = text
        cell.accessoryType = .none
        if let answer = self.observableAnswer.value, answer.content.contains(text) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        var newAnswer = observableAnswer.value ?? answer ?? MyAnswer.emptyContent(question: question)
        
        let option = options.value[indexPath.row]
        
        if question.multipleSelection {
            if let index = newAnswer.content.firstIndex(of: option) {
                newAnswer.content.remove(at: index)
                cell.accessoryType = .none
            } else {
                newAnswer.content.append(option)
                cell.accessoryType = .checkmark
            }
        } else {
            newAnswer.content = [option]
            _ = tableView.visibleCells.map {$0.accessoryType = .none}
            cell.accessoryType = .checkmark
        }
        
        observableAnswer.accept(newAnswer)
        
    }
    
    private let bag = DisposeBag()
    
}
