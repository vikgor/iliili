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
    Question(option1: "Иметь 100 рублей", option2: "Иметь 100 друзей"),
    Question(option1: "Путешествие в прошлое", option2: "Путешествие в будущее"),
    Question(option1: "Изучить океан", option2: "Изучить космос"),
    Question(option1: "Уметь летать", option2: "Становиться невидимкой"),
    Question(option1: "Бесконечный запас еды", option2: "Бесплатный вайфай везде")
    ]
    
    func getNewQuestion() {
        let options = questions.randomElement()
        presenter?.newQuestion(question: options!)
    }
    
}
