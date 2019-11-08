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
        animateButton(sender)
        interactor?.getNewQuestion()
    }
    @IBAction func option2(_ sender: UIButton) {
        animateButton(sender)
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
    
    func getNewQuestion(question: Question) {
        option1.setTitle(question.options.option1, for: .normal)
        option2.setTitle(question.options.option2, for: .normal)
    }
    
    
    //MARK: Где должны находиться UI функции (анимации, расположение объектов)?
    func animateButton(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.2, delay: 0,
                         animations: {
//                            sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            sender.transform = CGAffineTransform(rotationAngle: 69)
//                            sender.transform = CGAffineTransform(translationX: 50, y: 0)
                            
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }
    
}
