//
//  FirebaseService.swift
//  iliili
//
//  Created by Viktor Gordienko on 12/6/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseDelegate {
    func convertFirebaseDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void)
    func sendVote(questionNumber: Int, optionVotesStringTag: String)
    func countVotes(optionVotesTag: String, questionNumber: Int, votes: Int)
    
    func countVotesDependingOnTag(optionVotesTag: String, questionNumber: Int, votes: Int)
//    func getVotesPercentage(snapshot: DataSnapshot, votes: Int, questionNumber: Int, optionVotesTag: String)
}

class FirebaseService {
    var firebaseDelegate: FirebaseDelegate?
    let database = Database.database().reference().child("questions")
    let optionVotesTag = ("option1votes", "option2votes")
    var votesPercent: Int?
}

extension FirebaseService: FirebaseDelegate {
    
    func convertFirebaseDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void) {
        var array: [Question]?
        database.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                array = try! JSONDecoder().decode([Question].self, from: jsonData)
            } catch let error {
                print(error)
            }
            if let questions = array {
                completion(questions)
            }
        })
    }
    
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
            var percentageOfVotes: Int?
            self.getVotesPercentage(snapshot: snapshot,
                                    votes: votes,
                                    questionNumber: questionNumber,
                                    optionVotesTag: optionVotesTag) { value in
                                        percentageOfVotes = value
            }

//            print("votesPercent = \(self.votesPercent)")
//            print("percentageOfVotes = \(percentageOfVotes)")
            
        })
    }
    
    func getVotesPercentage(snapshot: DataSnapshot,
                            votes: Int,
                            questionNumber: Int,
                            optionVotesTag: String,
                            completion: (Int) -> Void) {
        if let otherVotes = snapshot.value as? Int {
            let percentageOfVotes = Int((Double(votes) / Double((votes + otherVotes)))*100)
            
            print("Question set: \(questionNumber) | Votes for chosen option: \(votes) | Votes for other option: \(otherVotes) | Percentage \(percentageOfVotes)%")
            
            self.votesPercent = percentageOfVotes
            
            completion(percentageOfVotes)
            
//            switch optionVotesTag {
//            case self.optionVotesTag.1:
////                self.presenter?.showVotesAnimationOption1(percentageOfVotes: percentageOfVotes)
//                break;
//            case self.optionVotesTag.0:
////                self.presenter?.showVotesAnimationOption2(percentageOfVotes: percentageOfVotes)
//                break;
//            default: ()
//            break;
//            }
            
        }
    }
    
}
