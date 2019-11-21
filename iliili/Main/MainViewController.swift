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
    
    @IBAction func option1(_ sender: UIButton) {
        animateButton(sender, rotationAngle: 69)
        interactor?.getNewQuestion(sender: option1, questions: questions!)
    }
    @IBAction func option2(_ sender: UIButton) {
        animateButton(sender, rotationAngle: -69)
        interactor?.getNewQuestion(sender: option2, questions: questions!)
    }
    
    var questions: [Question]?
    
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
//        interactor?.getFirstQuestion(questions: questions!)
        option1.tag = 1
        option2.tag = 2
        interactor?.getRandomNumber(questions: questions!)
        interactor?.getNewQuestion(questions: questions!)
    }
    
    func getNewQuestion(question: Question) {
        option1.setTitle(question.options.option1, for: .normal)
        option2.setTitle(question.options.option2, for: .normal)
    }
    
    
    func animateButton(_ sender: UIButton, rotationAngle: Int) {
        UIButton.animate(withDuration: 0.2,
                         delay: 0,
                         animations: {
                            sender.transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }
    
}
