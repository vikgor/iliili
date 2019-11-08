//
//  StartViewController.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/8/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var startGame: UIButton!
    @IBAction func startGame(_ sender: Any) {
        _ = interactor?.getStructFromJSON()
    }
    
    var interactor: StartInteractor?
       
    func setup() {
        let interactor = StartInteractor()
        self.interactor = interactor
        let presenter = StartPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    
}
