//
//  MainInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class MainInteractor {
    var presenter: MainPresenter?
    var previousRandomQuestion: Int?
    let optionVotesString = ("option1votes", "option2votes")
    
    let database = Database.database().reference().child("questions")
    
    func getNewQuestion(questions: [Question]) {
        let randomQuestion = Int.random(in: 0...(questions.count - 1))
        let options = questions[randomQuestion]
        previousRandomQuestion = randomQuestion
        presenter?.getNewQuestion(question: options)
    }
        
    func getNewQuestion(questions: [Question], sender: UIButton, otherOption: UIButton) {
        let randomQuestion = Int.random(in: 0...(questions.count - 1))
        let options = questions[randomQuestion]
        
        switch sender.tag {
        case 1:
            sendVote(questionNumber: previousRandomQuestion!, optionVotes: optionVotesString.0, backgroundColor: sender.backgroundColor!, otherBackgroundColor: otherOption.backgroundColor!)
            break;
        case 2:
            sendVote(questionNumber: previousRandomQuestion!, optionVotes: optionVotesString.1, backgroundColor: sender.backgroundColor!, otherBackgroundColor: otherOption.backgroundColor!)
            break;
        default: ()
        break;
        }
        
        previousRandomQuestion = randomQuestion
        presenter?.getNewQuestion(question: options)
    }
    
    func sendVote(questionNumber: Int, optionVotes: String, backgroundColor: UIColor, otherBackgroundColor: UIColor) {
        database.child(String(questionNumber)).child("options").child(optionVotes).observeSingleEvent(of: .value, with: { snapshot in
            var votes = snapshot.value as? Int
            votes! += 1
            self.database.child(String(questionNumber)).child("options").child(optionVotes).setValue(votes)
            self.getPercentage(optionVotes: optionVotes, questionNumber: questionNumber, votes: votes!, backgroundColor: backgroundColor, otherBackgroundColor: otherBackgroundColor)
    })
        
    }
    
    func getPercentage(optionVotes: String, questionNumber: Int, votes: Int, backgroundColor: UIColor, otherBackgroundColor: UIColor) {
        if optionVotes != self.optionVotesString.0 {
            self.database.child(String(questionNumber)).child("options").child(self.optionVotesString.0).observeSingleEvent(of: .value, with: { snapshot in
                let otherVotes = snapshot.value as? Int
                let percentageOfVotes = Int((Double(votes) / Double((votes + otherVotes!)))*100)
                self.presenter?.showVotesColor(percentageOfVotes: percentageOfVotes, backgroundColor: backgroundColor, otherBackgroundColor: otherBackgroundColor)
                
                print("Question set: ", questionNumber, "| Votes for chosen option: ", votes, "| Votes for other option: ", otherVotes!, "| Percentage", percentageOfVotes,"%")
            })
        } else {
            self.database.child(String(questionNumber)).child("options").child(self.optionVotesString.1).observeSingleEvent(of: .value, with: { snapshot in
                let otherVotes = snapshot.value as? Int
                let percentageOfVotes = Int((Double(votes) / Double((votes + otherVotes!)))*100)
                self.presenter?.showVotesColor(percentageOfVotes: percentageOfVotes, backgroundColor: backgroundColor, otherBackgroundColor: otherBackgroundColor)
                
                print("Question set: ", questionNumber, "| Votes for chosen option: ", votes, "| Votes for other option: ", otherVotes!, "| Percentage", percentageOfVotes,"%")
            })
        }
    }
    
}
