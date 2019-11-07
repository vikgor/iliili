//
//  ViewController.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/6/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    
    @IBAction func option1(_ sender: Any) {
        interactor?.getNewQuestion()
    }
    @IBAction func option2(_ sender: Any) {
        interactor?.getNewQuestion()
    }
    
    
    var interactor: MainInteractor?
    func setup() {
        let interactor = MainInteractor()
        self.interactor = interactor
        let presenter = MainPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor?.getNewQuestion()
    }
    
    
    func newQuestion(question: Question) {
        option1.setTitle(question.option1, for: .normal)
        option2.setTitle(question.option2, for: .normal)
    }
    

}

