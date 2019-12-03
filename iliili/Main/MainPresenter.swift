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
    
    func showVotesAnimation1(percentageOfVotes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor) {
        let chosenVotesXPoint: CGFloat = 0
        let chosenVotesXPointAnimate: CGFloat = 0
        viewController?.showVotesAnimation(percentageOfVotes: percentageOfVotes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor, chosenVotesXPoint: chosenVotesXPoint, chosenVotesXPointAnimate: chosenVotesXPointAnimate)
    }
    func showVotesAnimation2(percentageOfVotes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor) {
        let chosenVotesXPoint = viewController?.view.bounds.size.width
        let chosenVotesXPointAnimate = (viewController?.view.bounds.size.width)! * (1 - CGFloat(percentageOfVotes)/100)
        viewController?.showVotesAnimation(percentageOfVotes: percentageOfVotes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor, chosenVotesXPoint: chosenVotesXPoint!, chosenVotesXPointAnimate: chosenVotesXPointAnimate)
    }
}
