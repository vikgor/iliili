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
    
//    func getFirstQuestion(questions: [Question]) {
//        let options = questions.randomElement()
//        presenter?.getNewQuestion(question: options!)
//    }
    
    func sendVote(questionNumber: Int, optionVotes: String) {
        print("question set ", questionNumber)
    Database.database().reference().child("questions").child(String(questionNumber)).child("options").child(String(optionVotes)).observeSingleEvent(of: .value, with: { snapshot in
        let valString = snapshot.value as? Int
        print("Votes before:", valString!)
        let value = valString! + 1
        print("Votes after:", value)
            
        Database.database().reference().child("questions").child(String(questionNumber)).child("options").child(String(optionVotes)).setValue(value)
    })
    }
    
    
    var randomShit: Int?
    func getRandomNumber(questions: [Question]) {
        randomShit = Int.random(in: 0...(questions.count - 1))
    }
        
    func getNewQuestion(sender: UIButton, questions: [Question]) {
        
        let randomQuestion = Int.random(in: 0...(questions.count - 1))
        let options = questions[randomQuestion]
        
        
        switch sender.tag {
        case 1:
            print("option 1 tapped")
            
            sendVote(questionNumber: randomShit!, optionVotes: "option1votes")
            
            break;
        case 2:
            print("option 2 tapped")
            
            sendVote(questionNumber: randomShit!, optionVotes: "option2votes")
            
            break;
        default: ()
        break;
        }
        
        randomShit = randomQuestion
        presenter?.getNewQuestion(question: options)
        
    }
}
