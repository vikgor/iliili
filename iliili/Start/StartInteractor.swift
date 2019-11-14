//
//  StartInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/8/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation

class StartInteractor {
    
    var presenter: StartPresenter?
    
//    let questionsList = "https://bjayds1.fvds.ru/questions.json"
    let questionsList = "https://firebasestorage.googleapis.com/v0/b/iliili.appspot.com/o/questions.json?alt=media&token=7e0b14a4-f0c6-4858-8103-1cd6dae40c1f"
    
    func start() {
        print("start")
        presenter?.showLoading()
        DispatchQueue.global(qos: .background).async {
            self.getStructFromJSON()
        }
    }
    
    func getStructFromJSON() {
        var questions: [Question]?
        if let url = URL(string: questionsList) {
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

            presenter?.receivedQuestions(questions: questions!)   
        }
    }
}
