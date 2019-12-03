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

struct Question: Codable {
    var id: Int
    var options: Options
}

struct Options: Codable {
    var option1: String
    var option2: String
    var option1votes: Int
    var option2votes: Int
}

class MainInteractor {
    var presenter: MainPresenter?
    let questionsFirebase = "https://firebasestorage.googleapis.com/v0/b/iliili.appspot.com/o/questions.json?alt=media&token=7e0b14a4-f0c6-4858-8103-1cd6dae40c1f"
    let optionVotesTag = ("option1votes", "option2votes")
    let database = Database.database().reference().child("questions")
    
    var randomQuestionNumber: Int?
    var previousRandomQuestionNumber: Int?
    
    var questions: [Question]?
    var question: Question?
    
//    try to read the first set of random questions into a local variable
//    var firstTenQuestion: [Question]?
    
    func initQuestion(){
        presenter?.showLoading()
        getQuestionsFromFirebase()
    }
    
    func getQuestionsFromFirebase() {
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: self.questionsFirebase) {
                    do {
                        //this do statement doesn't really do anything yet since the link doesn't containt the JSON itself, therefore it is going straight to catch - reading from local file
                        print("reading from the server")
                        let data = try Data(contentsOf: url as URL)
                        let decoder = JSONDecoder()
                        self.questions = try decoder.decode([Question].self, from: data)
                    } catch {
                        print("reading from the local file")
                        let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
                        let data = try! Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        self.questions = try! decoder.decode([Question].self, from: data)
                    }
                    
                    DispatchQueue.main.async {
                        self.convertFirebaseDatasnapshotToQuestion { (questions) in
                            self.getNewQuestion(questions: questions)
                        }
                    }
                    
                }
            }
        }
        
        func convertFirebaseDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void) {
            Database.database().reference().child("questions").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value else { return }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let questions = try JSONDecoder().decode([Question].self, from: jsonData)
                    completion(questions)
                } catch let error {
                    print(error)
                }
            })
        }
    
    
    //Called only once
    func getNewQuestion(questions: [Question]) {
        randomQuestionNumber = Int.random(in: 0...(questions.count - 1))
        question = questions[randomQuestionNumber!]
        previousRandomQuestionNumber = randomQuestionNumber
        presenter?.showNewQuestion(question: question!)
    }
    
    func choseOption1(chosenOption: UIButton, otherOption: UIButton) {
        getNewQuestion(questions: questions!, chosenOption: chosenOption, otherOption: otherOption, optionVotesStringTag: optionVotesTag.0)
        
    }
    
    func choseOption2(chosenOption: UIButton, otherOption: UIButton) {
        getNewQuestion(questions: questions!, chosenOption: chosenOption, otherOption: otherOption, optionVotesStringTag: optionVotesTag.1)
        
    }
    
    func getNewQuestion(questions: [Question], chosenOption: UIButton, otherOption: UIButton, optionVotesStringTag: String) {
        sendVote(questionNumber: previousRandomQuestionNumber!, chosenOption: chosenOption, otherOption: otherOption, optionVotesStringTag: optionVotesStringTag)
        randomQuestionNumber = Int.random(in: 0...(questions.count - 1))
        question = questions[randomQuestionNumber!]
        previousRandomQuestionNumber = randomQuestionNumber
        presenter?.showNewQuestion(question: question!)
    }
    
    func sendVote(questionNumber: Int, chosenOption: UIButton, otherOption: UIButton, optionVotesStringTag: String) {
        database.child(String(questionNumber)).child("options").child(optionVotesStringTag).observeSingleEvent(of: .value, with: { snapshot in
            var votes = snapshot.value as? Int
            votes! += 1
            self.database.child(String(questionNumber)).child("options").child(optionVotesStringTag).setValue(votes)
            self.countVotesDependingOnTag(optionVotesTag: optionVotesStringTag, questionNumber: questionNumber, votes: votes!, chosenOption: chosenOption, otherOption: otherOption)
        })
    }
    
    func countVotesDependingOnTag(optionVotesTag: String, questionNumber: Int, votes: Int, chosenOption: UIButton, otherOption: UIButton) {
        switch optionVotesTag {
        case self.optionVotesTag.1:
            countVotes(optionVotesTag: self.optionVotesTag.0, questionNumber: questionNumber, votes: votes, chosenOption: chosenOption, otherOption: otherOption)
            break;
        case self.optionVotesTag.0:
            countVotes(optionVotesTag: self.optionVotesTag.1, questionNumber: questionNumber, votes: votes, chosenOption: chosenOption, otherOption: otherOption)
            break;
        default: ()
        break;
        }
    }
    
    func countVotes(optionVotesTag: String, questionNumber: Int, votes: Int, chosenOption: UIButton, otherOption: UIButton) {
        self.database.child(String(questionNumber)).child("options").child(optionVotesTag).observeSingleEvent(of: .value, with: { snapshot in
            self.getVotesPercentage(snapshot: snapshot, votes: votes, chosenOption: chosenOption, otherOption: otherOption, questionNumber: questionNumber, optionVotesTag: optionVotesTag)
        })
    }
    
    func getVotesPercentage(snapshot: DataSnapshot, votes: Int, chosenOption: UIButton, otherOption: UIButton, questionNumber: Int, optionVotesTag: String) {
        let otherVotes = snapshot.value as? Int
        let percentageOfVotes = Int((Double(votes) / Double((votes + otherVotes!)))*100)
        
        switch optionVotesTag {
        case self.optionVotesTag.1:
            self.presenter?.showVotesAnimation1(percentageOfVotes: percentageOfVotes, chosenOptionBackgroundColor: chosenOption.backgroundColor!, otherOptionBackgroundColor: otherOption.backgroundColor!)
            break;
        case self.optionVotesTag.0:
            self.presenter?.showVotesAnimation2(percentageOfVotes: percentageOfVotes, chosenOptionBackgroundColor: chosenOption.backgroundColor!, otherOptionBackgroundColor: otherOption.backgroundColor!)
            break;
        default: ()
        break;
        }
        
        print("Question set: ", questionNumber, "| Votes for chosen option: ", votes, "| Votes for other option: ", otherVotes!, "| Percentage", percentageOfVotes,"%")
    }
    
}
