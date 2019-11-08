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
    var startInteractor = StartInteractor()
    

    
    
    func getNewQuestion() {
            
        let options = startInteractor.getStructFromJSON().randomElement()
        presenter?.getNewQuestion(question: options!)
    }

}
