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
    var firebaseService: FirebaseService?
    var firebaseDelegate: FirebaseDelegate?
    
    let questionsFirebase = "https://firebasestorage.googleapis.com/v0/b/iliili.appspot.com/o/questions.json?alt=media&token=7e0b14a4-f0c6-4858-8103-1cd6dae40c1f"
    let optionVotesTag = ("option1votes", "option2votes")
    
    var randomQuestionNumber: Int?
    var previousRandomQuestionNumber: Int?
    
    var questions: [Question]? = []
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
                        self.firebaseService?.convertFirebaseDatasnapshotToQuestion() { questions in
                            self.questions = questions
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
            firebaseService?.sendVote(questionNumber: number, optionVotesStringTag: optionVotesStringTag)
            getNewQuestion()
            name()
        }
    }
    
    func name() {
        print(firebaseService?.votesPercent)
    }
    
    func chooseOption1() {
        getNewQuestion(optionVotesStringTag: optionVotesTag.0)
    }
    
    func chooseOption2() {
        getNewQuestion(optionVotesStringTag: optionVotesTag.1)
    }
    
//    func getVotesPercentage(snapshot: DataSnapshot,
//                            votes: Int,
//                            questionNumber: Int,
//                            optionVotesTag: String) {
//        if let otherVotes = snapshot.value as? Int {
//            let percentageOfVotes = Int((Double(votes) / Double((votes + otherVotes)))*100)
//
//            print("Question set: \(questionNumber) | Votes for chosen option: \(votes) | Votes for other option: \(otherVotes) | Percentage \(percentageOfVotes)%")
//
//            switch optionVotesTag {
//            case self.optionVotesTag.1:
//                self.presenter?.showVotesAnimationOption1(percentageOfVotes: percentageOfVotes)
//                break;
//            case self.optionVotesTag.0:
//                self.presenter?.showVotesAnimationOption2(percentageOfVotes: percentageOfVotes)
//                break;
//            default: ()
//            break;
//            }
//
//        }
//    }
    
    
    
}
