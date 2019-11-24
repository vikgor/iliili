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
    
    var questions: Question?
    
    func getNewQuestion(question: Question) {
        viewController?.getNewQuestion(question: question)
    }
    
    func showVotesColor(percentageOfVotes: Int, backgroundColor: UIColor, otherBackgroundColor: UIColor) {
        viewController?.showVotesColor(percentageOfVotes: percentageOfVotes, backgroundColor: backgroundColor, otherBackgroundColor: otherBackgroundColor)
    }
    
}
