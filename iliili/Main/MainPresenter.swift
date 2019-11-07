//
//  MainPresenter.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation

class MainPresenter {
    
    weak var viewController: MainViewController?
    
    var questions: Question?
    
    func newQuestion(question: Question) {
        viewController?.newQuestion(question: question)
    }
    
}
