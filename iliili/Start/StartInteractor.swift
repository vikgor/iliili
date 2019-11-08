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
    
    let questionsList = "https://bjayds1.fvds.ru/questions.json"
    
    func getStructFromJSON() -> [Question] {
        if let url = URL(string: questionsList) {
            do {
                // load from server
                let data = try Data(contentsOf: url as URL)
                let decoder = JSONDecoder()
                print("called the server file")
                return try decoder.decode([Question].self, from: data)
                
            } catch {
                // load from the local file
                let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
                let data = try! Data(contentsOf: url)
                let decoder = JSONDecoder()
                print("called the local file")
                return try! decoder.decode([Question].self, from: data)
            }
        } else {
            //TODO: what to I put here?
            // the URL was bad!
            return []
        }
    }
}
