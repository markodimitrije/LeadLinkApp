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
            observableSearch.subscribe(onNext: { [weak self] (search) in
                guard let sSelf = self else {return}
                let options = sSelf.countries.isEmpty ? sSelf.question.qOptions : sSelf.countries
                if search == "" {
                    sSelf.optionsToDisplay.accept(options)
                } else {
                    let contained = options.filter({ option -> Bool in
                        return NSString.init(string: option.lowercased()).contains(search?.lowercased() ?? "")
                    })
                    sSelf.optionsToDisplay.accept(contained)
                }
                sSelf.tableView.reloadData()
            }).disposed(by: bag)
        }
    }
    
    var question: QuestionProtocol
    var tableView: UITableView!
    
    private var optionsToDisplay = BehaviorRelay<[String]>(value: [])
    private var answer: MyAnswerProtocol?
    
    private var countries = [String]()
    
    init(selectOptionTextViewModel: SelectOptionTextFieldViewModel) {
        
        func checkIfOptionsShouldBeCountries() {
            if selectOptionTextViewModel.question.qOptions.first == QuestionPersonalInfoKey.country_id.rawValue {
                let countriesManager = CountriesManager()
                self.countries = Array(countriesManager.countries.values).sorted()
            }
        }
        
        self.question = selectOptionTextViewModel.question
        self.answer = selectOptionTextViewModel.answer
        super.init()
        checkIfOptionsShouldBeCountries()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsToDisplay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        let text = optionsToDisplay.value[indexPath.row]
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
        
        let option = optionsToDisplay.value[indexPath.row]
        
        if question.qMultipleSelection {
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
        //print("emitujem.observableAnswer.newAnswer.content.accept = \(newAnswer.content) ")
        observableAnswer.accept(newAnswer)
        
    }
    
    private let bag = DisposeBag()
    
}
