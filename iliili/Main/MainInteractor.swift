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
    
    //TODO: Read the JSON from this URL
    let questionsList = "https://8137147.xyz/questions.json"
    
    func getNewQuestion() {
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
