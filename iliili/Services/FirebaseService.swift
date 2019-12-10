//
//  FirebaseService.swift
//  iliili
//
//  Created by Viktor Gordienko on 12/6/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseService: FirebaseDelegate {
    
    var interactor: MainInteractor?
    let database = Database.database().reference().child("questions")
//
//}
//
//extension FirebaseService: FirebaseDelegate {
//
    func convertFirebaseDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void) {
        interactor?.firebaseDelegate = self
        
        database.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let array = try! JSONDecoder().decode([Question].self, from: jsonData)
                self.interactor?.questions = array
                if let questions = self.interactor?.questions {
                    completion(questions)
                }
            } catch let error {
                print(error)
            }
        })
    }
    
    func sendVote(questionNumber: Int, optionVotesStringTag: String) {
        database.child(String(questionNumber)).child("options").child(optionVotesStringTag).observeSingleEvent(of: .value, with: { snapshot in
            if var votes = snapshot.value as? Int {
                votes += 1
                self.database.child(String(questionNumber)).child("options").child(optionVotesStringTag).setValue(votes)
                self.interactor?.countVotesDependingOnTag(optionVotesTag: optionVotesStringTag,
                                                          questionNumber: questionNumber,
                                                          votes: votes)
            }
        })
    }
    
    func countVotes(optionVotesTag: String, questionNumber: Int, votes: Int) {
        self.database.child(String(questionNumber)).child("options").child(optionVotesTag).observeSingleEvent(of: .value, with: { snapshot in
            self.interactor?.getVotesPercentage(snapshot: snapshot,
                                                votes: votes,
                                                questionNumber: questionNumber,
                                                optionVotesTag: optionVotesTag)
        })
    }
    
}


/*
 
 Firebase service does:
 
 1. Get all the questions -> [question]
 2. Get a random question
 3. Count the vote depending on a tag
 4. Vote++
 5. Send the vote
 
 */
