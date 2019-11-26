//
//  MainPresenter.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation
import UIKit

class MainPresenter {
    
    weak var viewController: MainViewController?
    
    func showLoading() {
        viewController?.showLoading()
    }
    
    func showNewQuestion(question: Question) {
        viewController?.hideLoading()
        viewController?.showNewQuestionOnButtonLabels(question: question)
    }
    
    func showVotesAnimation(percentageOfVotes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor) {
        viewController?.showVotesAnimation(percentageOfVotes: percentageOfVotes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor)
    }
    
}
