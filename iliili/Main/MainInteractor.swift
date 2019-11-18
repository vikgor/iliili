//
//  MainInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation

class MainInteractor {
    var presenter: MainPresenter?
    var startInteractor = StartInteractor()
    
    func getNewQuestion(questions: [Question]) {
//        let options = startInteractor.getStructFromJSON().randomElement()
        let options = questions.randomElement()
        presenter?.getNewQuestion(question: options!)
    }

}
