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
    var fireabseService: FirebaseService?
    let questionsFirebase = "https://firebasestorage.googleapis.com/v0/b/iliili.appspot.com/o/questions.json?alt=media&token=7e0b14a4-f0c6-4858-8103-1cd6dae40c1f"
    let optionVotesTag = ("option1votes", "option2votes")
    
    var randomQuestionNumber: Int?
    var previousRandomQuestionNumber: Int?
    
    var questions: [Question]?
    var question: Question?
    
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
//                        self.convertFirebaseDatasnapshotToQuestion { (questions) in
//                            self.getNewQuestion()
//                        }
                        
                        //MARK: firebase 1
                        
                        self.fireabseService?.convertFirebaseDatasnapshotToQuestion { (questions) in
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
    
    //MARK: New question
    func getQuestion() -> Question? {
        if let array = questions {
            randomQuestionNumber = Int.random(in: 0...(array.count - 1))
            if let random = randomQuestionNumber {
                question = questions?[random]
                if let newQuestion = question {
                    previousRandomQuestionNumber = randomQuestionNumber
                    return newQuestion
                }
            }
        }
        return nil
    }
    
    //Called only once, on the view load
    func getNewQuestion() {
        if let question = getQuestion() {
            presenter?.showNewQuestion(question: question)
        }
    }
    
    func getNewQuestion(optionVotesStringTag: String) {
        if let number = previousRandomQuestionNumber {
            fireabseService?.sendVote(questionNumber: number, optionVotesStringTag: optionVotesStringTag)
            getNewQuestion()
        }
    }
    
    func chooseOption1() {
        getNewQuestion(optionVotesStringTag: optionVotesTag.0)
    }
    
    func chooseOption2() {
        getNewQuestion(optionVotesStringTag: optionVotesTag.1)
    }
    
    
    func countVotesDependingOnTag(optionVotesTag: String, questionNumber: Int, votes: Int) {
        switch optionVotesTag {
        case self.optionVotesTag.1:
            fireabseService?.countVotes(optionVotesTag: self.optionVotesTag.0,
                                        questionNumber: questionNumber,
                                        votes: votes)
            break;
        case self.optionVotesTag.0:
            fireabseService?.countVotes(optionVotesTag: self.optionVotesTag.1,
                                        questionNumber: questionNumber,
                                        votes: votes)
            break;
        default: ()
        break;
        }
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
    
    
//    let database = Database.database().reference().child("questions")
    
//    func convertFirebaseDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void) {
//        fireabseService?.database.observeSingleEvent(of: .value, with: { snapshot in
//            guard let value = snapshot.value else { return }
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
//                self.questions = try JSONDecoder().decode([Question].self, from: jsonData)
//                print(self.questions)
//                if let questions = self.questions {
//                    completion(questions)
//                }
//            } catch let error {
//                print(error)
//            }
//        })
//    }
//
//
//    MARK: Vote
//    func sendVote(questionNumber: Int, optionVotesStringTag: String) {
//        database.child(String(questionNumber)).child("options").child(optionVotesStringTag).observeSingleEvent(of: .value, with: { snapshot in
//            if var votes = snapshot.value as? Int {
//                votes += 1
//                self.database.child(String(questionNumber)).child("options").child(optionVotesStringTag).setValue(votes)
//                self.countVotesDependingOnTag(optionVotesTag: optionVotesStringTag,
//                                              questionNumber: questionNumber,
//                                              votes: votes)
//            }
//        })
//    }
//
//
//    func countVotes(optionVotesTag: String, questionNumber: Int, votes: Int) {
//        self.database.child(String(questionNumber)).child("options").child(optionVotesTag).observeSingleEvent(of: .value, with: { snapshot in
//            self.getVotesPercentage(snapshot: snapshot,
//                                    votes: votes,
//                                    questionNumber: questionNumber,
//                                    optionVotesTag: optionVotesTag)
//        })
//    }
    
    
}
