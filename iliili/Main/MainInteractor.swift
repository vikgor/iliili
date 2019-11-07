//
//  MainInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation

struct Question: Codable {
    var id: Int
    var options: Options
}

struct Options: Codable {
    var option1: String
    var option2: String
}

class MainInteractor {
    var presenter: MainPresenter?
    
    //TODO: Move this to plist/json - DONE
//    var questions: [Question] = [
//        Question(option1: "Иметь 100 рублей", option2: "Иметь 100 друзей"),
//        Question(option1: "Путешествие в прошлое", option2: "Путешествие в будущее"),
//        Question(option1: "Изучить океан", option2: "Изучить космос"),
//        Question(option1: "Уметь летать", option2: "Становиться невидимкой"),
//        Question(option1: "Бесконечный запас еды", option2: "Бесплатный вайфай везде")
//    ]

    var questions: [Question] = [
           Question(id: 1, options: Options(option1: "Иметь 100 рублей", option2: "Иметь 100 друзей"))
       ]
    
    func getNewQuestion() {
//        let options = questions.randomElement()
        
        let options = getStructFromJSON().randomElement()
        presenter?.getNewQuestion(question: options!)
    }
    
    
        func getStructFromJSON() -> [Question] {
            let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try! decoder.decode([Question].self, from: data)
        }

}
