//
//  StartInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/8/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation
import FirebaseDatabase


class StartInteractor {
    
    var presenter: StartPresenter?
//    let questionsFirebase = "https://firebasestorage.googleapis.com/v0/b/iliili.appspot.com/o/questions.json?alt=media&token=7e0b14a4-f0c6-4858-8103-1cd6dae40c1f"
    
    func start() {
//        presenter?.showLoading()
//        getQuestions()
        presenter?.showNextScreen()
    }
    
//    func getQuestions() {
//        DispatchQueue.global(qos: .background).async {
//            var questions: [Question]?
//            if let url = URL(string: self.questionsList) {
//                do {
//                    print("reading from the server")
//                    let data = try Data(contentsOf: url as URL)
//                    let decoder = JSONDecoder()
//                    questions = try decoder.decode([Question].self, from: data)
//                } catch {
//                    print("reading from the local file")
//                    let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
//                    let data = try! Data(contentsOf: url)
//                    let decoder = JSONDecoder()
//                    questions = try! decoder.decode([Question].self, from: data)
//                }
//
////                DispatchQueue.main.async {
////                    self.presenter?.receivedQuestions(questions: questions!)
////                }
//
//                DispatchQueue.main.async {
//                    self.convertFirebaseDatasnapshotToQuestion { (questions) in
//                        self.presenter?.receivedQuestions(questions: questions)
//                    }
//                }
//
//            }
//        }
//    }
//
//    func convertFirebaseDatasnapshotToQuestion(completion: @escaping ([Question]) -> Void) {
//        Database.database().reference().child("questions").observeSingleEvent(of: .value, with: { snapshot in
//            guard let value = snapshot.value else { return }
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
//                let questions = try JSONDecoder().decode([Question].self, from: jsonData)
//                completion(questions)
//            } catch let error {
//                print(error)
//            }
//        })
//    }
}
