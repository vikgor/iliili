//
//  MainInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation

struct Question {
    var option1: String
    var option2: String
}

class MainInteractor {
    var presenter: MainPresenter?
    
    var questions: [Question] = [
    Question(option1: "вопрос 1", option2: "вопрос 2"),
    Question(option1: "Путешествие в прошлое", option2: "Путешествие в будущее"),
    Question(option1: "Изучить океан", option2: "Изучить космос"),
    Question(option1: "Уметь летать", option2: "Становиться невидимкой"),
    Question(option1: "Бесконечный запас еды", option2: "Бесплатный вайфай везде")
    ]
    
    
    func getNewQuestion() {
        print("getNewQuestion called")
        
        let options = questions.randomElement()
        let newOption1 = options?.option1
        let newOption2 = options?.option2
        
//        print("\(newOption1) ИЛИ \(newOption2)")
        
        presenter?.getOption1(string: newOption1!)
        presenter?.getOption2(string: newOption2!)
        presenter?.test()
    }
    
}
