//
//  StartPresenter.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/8/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation

class StartPresenter {
    
    weak var viewController: StartViewController?
    
    func showNextScreen() {
        viewController?.showNextScreen()
    }
    
}
