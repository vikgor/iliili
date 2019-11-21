//
//  StartInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/8/19.
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

class StartInteractor {
    
    var presenter: StartPresenter?
    
    let questionsList = "https://firebasestorage.googleapis.com/v0/b/iliili.appspot.com/o/questions.json?alt=media&token=7e0b14a4-f0c6-4858-8103-1cd6dae40c1f"
    
    func start() {
        presenter?.showLoading()
        getStructFromJSON()
    }
    
    func convertDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void) {
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
    
    func getStructFromJSON() {
        DispatchQueue.global(qos: .background).async {
            var questions: [Question]?
            if let url = URL(string: self.questionsList) {
                do {
                    print("reading from the server file")
                    let data = try Data(contentsOf: url as URL)
                    let decoder = JSONDecoder()
                    questions = try decoder.decode([Question].self, from: data)
                    
                } catch {
                    print("reading from the local file")
                    let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    questions = try! decoder.decode([Question].self, from: data)
                }
                                
//                DispatchQueue.main.async {
//                    self.presenter?.receivedQuestions(questions: questions!)
//                }
                
                DispatchQueue.main.async {
                    self.convertDatasnapshotToQuestion { (questions) in
                        self.presenter?.receivedQuestions(questions: questions)
                    }
                }
                
            }
        }
    }
}
