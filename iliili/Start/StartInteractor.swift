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
    
    func start() {
        presenter?.showNextScreen()
    }
    
}
