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
    
    let questionsList = "https://8137147.xyz/questions.json"
    
    func getNewQuestion() {
        let options = getStructFromJSON().randomElement()
        presenter?.getNewQuestion(question: options!)
    }
    
    func getStructFromJSON() -> [Question] {
//        //Reading from local file
//        let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
        
        //Reading from a file online
        let myURL = NSURL(string: questionsList)
        let data = try! Data(contentsOf: myURL! as URL)
//        let data = try! Data(contentsOf: myURL! as URL, encoding: .windowsCP1251) Just in case Cyrillic is crazy
        
        let decoder = JSONDecoder()
        return try! decoder.decode([Question].self, from: data)
    }

}
