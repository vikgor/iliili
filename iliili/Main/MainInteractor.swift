//
//  MainInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation
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
    
    //TODO: try to read the first set of random questions into a local variable
    //    var firstTenQuestion: [Question]?
    
    func initQuestion() {
        presenter?.showLoading()
        getQuestionsFromFirebase()
    }
    
    func getQuestionsFromFirebase() {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: self.questionsFirebase) {
                do {
                    print("reading from the server")
                    _ = try Data(contentsOf: url as URL)
                    
                    DispatchQueue.main.async {
                        self.convertFirebaseDatasnapshotToQuestion { (questions) in
                            self.getNewQuestion()
                        }
                    }
                } catch {
                    print("reading from the local file")
                    if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
                        if let data = try? Data(contentsOf: url) {
                            let decoder = JSONDecoder()
                            self.questions = try? decoder.decode([Question].self, from: data)

                            DispatchQueue.main.async {
                                self.getNewQuestion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func convertFirebaseDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void) {
        database.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                self.questions = try JSONDecoder().decode([Question].self, from: jsonData)
                if let questions = self.questions {
                    completion(questions)
                }
            } catch let error {
                print(error)
            }
        })
    }
    
    //Called only once, on the view load
    func getNewQuestion() {
        if let array = questions {
            randomQuestionNumber = Int.random(in: 0...(array.count - 1))
            if let random = randomQuestionNumber {
                question = questions?[random]
                if let newQuestion = question {
                    previousRandomQuestionNumber = randomQuestionNumber
                    presenter?.showNewQuestion(question: newQuestion)
                }
            }
        }
    }
    
    func chooseOption1() {
        getNewQuestion(optionVotesStringTag: optionVotesTag.0)
    }
    
    func chooseOption2() {
        getNewQuestion(optionVotesStringTag: optionVotesTag.1)
    }
    
    //MARK: New question
    func getNewQuestion(optionVotesStringTag: String) {
        if let number = previousRandomQuestionNumber {
            sendVote(questionNumber: number, optionVotesStringTag: optionVotesStringTag)
            if let questionsArray = questions {
                randomQuestionNumber = Int.random(in: 0...(questionsArray.count - 1))
                if let random = randomQuestionNumber {
                    question = questions?[random]
                    if let newQuestion = question {
                        previousRandomQuestionNumber = randomQuestionNumber
                        presenter?.showNewQuestion(question: newQuestion)
                    }
                }
            }
        }
    }
    
    //MARK: Vote
    func sendVote(questionNumber: Int, optionVotesStringTag: String) {
        database.child(String(questionNumber)).child("options").child(optionVotesStringTag).observeSingleEvent(of: .value, with: { snapshot in
            if var votes = snapshot.value as? Int {
                votes += 1
                self.database.child(String(questionNumber)).child("options").child(optionVotesStringTag).setValue(votes)
                self.countVotesDependingOnTag(optionVotesTag: optionVotesStringTag,
                                              questionNumber: questionNumber,
                                              votes: votes)
            }
        })
    }
    
    func countVotesDependingOnTag(optionVotesTag: String, questionNumber: Int, votes: Int) {
        switch optionVotesTag {
        case self.optionVotesTag.1:
            countVotes(optionVotesTag: self.optionVotesTag.0,
                       questionNumber: questionNumber,
                       votes: votes)
            break;
        case self.optionVotesTag.0:
            countVotes(optionVotesTag: self.optionVotesTag.1,
                       questionNumber: questionNumber,
                       votes: votes)
            break;
        default: ()
        break;
        }
    }
    
    func countVotes(optionVotesTag: String, questionNumber: Int, votes: Int) {
        self.database.child(String(questionNumber)).child("options").child(optionVotesTag).observeSingleEvent(of: .value, with: { snapshot in
            self.getVotesPercentage(snapshot: snapshot,
                                    votes: votes,
                                    questionNumber: questionNumber,
                                    optionVotesTag: optionVotesTag)
        })
    }
    
    func getVotesPercentage(snapshot: DataSnapshot,
                            votes: Int,
                            questionNumber: Int,
                            optionVotesTag: String) {
        if let otherVotes = snapshot.value as? Int {
            let percentageOfVotes = Int((Double(votes) / Double((votes + otherVotes)))*100)
            
            switch optionVotesTag {
            case self.optionVotesTag.1:
                self.presenter?.showVotesAnimationOption1(percentageOfVotes: percentageOfVotes)
                break;
            case self.optionVotesTag.0:
                self.presenter?.showVotesAnimationOption2(percentageOfVotes: percentageOfVotes)
                break;
            default: ()
            break;
            }
            
            print("Question set: ", questionNumber,
                  "| Votes for chosen option: ", votes,
                  "| Votes for other option: ", otherVotes,
                  "| Percentage", percentageOfVotes,"%")
        }
    }
    
}
