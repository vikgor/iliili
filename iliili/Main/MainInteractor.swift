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
    var previousRandomQuestionNumber: Int?
    let optionVotesTag = ("option1votes", "option2votes")
    let database = Database.database().reference().child("questions")
    
    //Called only once
    func getNewQuestion(questions: [Question]) {
        let randomQuestion = Int.random(in: 0...(questions.count - 1))
        let question = questions[randomQuestion]
        previousRandomQuestionNumber = randomQuestion
        presenter?.getNewQuestion(question: question)
    }
    
    func getNewQuestion(questions: [Question], chosenOption: UIButton, otherOption: UIButton) {
        let randomQuestionNumber = Int.random(in: 0...(questions.count - 1))
        let question = questions[randomQuestionNumber]
        
        switch chosenOption.tag {
        case 1:
            sendVote(questionNumber: previousRandomQuestionNumber!, optionVotesTag: optionVotesTag.0, chosenOptionBackgroundColor: chosenOption.backgroundColor!, otherOptionBackgroundColor: otherOption.backgroundColor!)
            break;
        case 2:
            sendVote(questionNumber: previousRandomQuestionNumber!, optionVotesTag: optionVotesTag.1, chosenOptionBackgroundColor: chosenOption.backgroundColor!, otherOptionBackgroundColor: otherOption.backgroundColor!)
            break;
        default: ()
        break;
        }
        
        previousRandomQuestionNumber = randomQuestionNumber
        presenter?.getNewQuestion(question: question)
    }
    
    func sendVote(questionNumber: Int, optionVotesTag: String, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor) {
        database.child(String(questionNumber)).child("options").child(optionVotesTag).observeSingleEvent(of: .value, with: { snapshot in
            var votes = snapshot.value as? Int
            votes! += 1
            self.database.child(String(questionNumber)).child("options").child(optionVotesTag).setValue(votes)
            self.countVotesDependingOnTag(optionVotesTag: optionVotesTag, questionNumber: questionNumber, votes: votes!, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor)
        })
    }
    
    func countVotesDependingOnTag(optionVotesTag: String, questionNumber: Int, votes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor) {
        switch optionVotesTag {
        case self.optionVotesTag.1:
            countVotes(optionVotesTag: self.optionVotesTag.0, questionNumber: questionNumber, votes: votes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor)
            break;
        case self.optionVotesTag.0:
            countVotes(optionVotesTag: self.optionVotesTag.1, questionNumber: questionNumber, votes: votes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor)
            break;
        default: ()
        break;
        }
    }
    
    func countVotes(optionVotesTag: String, questionNumber: Int, votes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor) {
        self.database.child(String(questionNumber)).child("options").child(optionVotesTag).observeSingleEvent(of: .value, with: { snapshot in
            self.getVotesPercentage(snapshot: snapshot, votes: votes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor, questionNumber: questionNumber)
        })
    }
    
    func getVotesPercentage(snapshot: DataSnapshot, votes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor, questionNumber: Int) {
        let otherVotes = snapshot.value as? Int
        let percentageOfVotes = Int((Double(votes) / Double((votes + otherVotes!)))*100)
        self.presenter?.showVotesAnimation(percentageOfVotes: percentageOfVotes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor)
        print("Question set: ", questionNumber, "| Votes for chosen option: ", votes, "| Votes for other option: ", otherVotes!, "| Percentage", percentageOfVotes,"%")
    }
    
}
