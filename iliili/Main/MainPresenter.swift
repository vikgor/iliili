//
//  MainPresenter.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation

class MainPresenter {
    
    weak var viewController: MainViewController?
    
    func getOption1(string: String) {
        viewController?.getOption1(string: string)
        print("getOption1 called")
    }
    func getOption2(string: String) {
        viewController?.getOption2(string: string)
        print("getOption2 called")
    }
    
    func test() {
        print("test called")
    }
    
}
