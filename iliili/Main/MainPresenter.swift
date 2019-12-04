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
    
    func showVotesAnimationOption1(percentageOfVotes: Int) {
        let chosenVotesXPoint: CGFloat = 0
        let chosenVotesXPointAnimate: CGFloat = 0
        let otherOptionBackgroundColor = UIColor.systemGreen
        let chosenOptionBackgroundColor = UIColor.systemOrange
        viewController?.showVotesAnimation(percentageOfVotes: percentageOfVotes,
                                           chosenOptionBackgroundColor: chosenOptionBackgroundColor,
                                           otherOptionBackgroundColor: otherOptionBackgroundColor,
                                           chosenVotesXPoint: chosenVotesXPoint,
                                           chosenVotesXPointAnimate: chosenVotesXPointAnimate)
    }
    func showVotesAnimationOption2(percentageOfVotes: Int) {
        if let viewWidth = viewController?.view.bounds.size.width {
            let chosenVotesXPoint = viewWidth
            let chosenVotesXPointAnimate = viewWidth * (1 - CGFloat(percentageOfVotes)/100)
            let otherOptionBackgroundColor = UIColor.systemOrange
            let chosenOptionBackgroundColor = UIColor.systemGreen
            viewController?.showVotesAnimation(percentageOfVotes: percentageOfVotes,
                                               chosenOptionBackgroundColor: chosenOptionBackgroundColor,
                                               otherOptionBackgroundColor: otherOptionBackgroundColor,
                                               chosenVotesXPoint: chosenVotesXPoint,
                                               chosenVotesXPointAnimate: chosenVotesXPointAnimate)
        }
    }
}
