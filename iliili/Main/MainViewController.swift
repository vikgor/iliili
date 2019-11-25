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

    @IBOutlet weak var iliLabel: UILabel!
    
    @IBAction func option1(_ sender: UIButton) {
        animateButton(sender, rotationAngle: 69)
        interactor?.getNewQuestion(questions: questions!, chosenOption: option1, otherOption: option2)
    }
    @IBAction func option2(_ sender: UIButton) {
        animateButton(sender, rotationAngle: -69)
        interactor?.getNewQuestion(questions: questions!, chosenOption: option2, otherOption: option1)
    }
    
    var interactor: MainInteractor?
    var questions: [Question]?
    
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
        option1.tag = 1
        option2.tag = 2
        interactor?.getNewQuestion(questions: questions!)
    }
    
    func getNewQuestion(question: Question) {
        option1.setTitle(question.options.option1, for: .normal)
        option2.setTitle(question.options.option2, for: .normal)
    }
    
    //MARK: Button animation
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
        hideIliLabel()
    }
    //MARK: Do I need this?
    func hideIliLabel() {
        UILabel.animate(withDuration: 1.0) {
            self.iliLabel.alpha = 0
        }
    }
    
    
    //MARK: Show votes animations
    func showVotesAnimation(percentageOfVotes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor) {
        
        let otherVotes = UIView(frame: CGRect(x: 0, y: self.view.bounds.size.height/2-25, width: self.view.bounds.size.width, height: 50))
        otherVotes.backgroundColor = otherOptionBackgroundColor
        self.view.addSubview(otherVotes)
        otherVotes.layer.cornerRadius = 10
//        votesBackground.layer.borderWidth = 0.5
//        votesBackground.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        
        let chosenVotes = UIView(frame: CGRect(x: 0, y: self.view.bounds.size.height/2-25, width: 0, height: 50))
        chosenVotes.backgroundColor = chosenOptionBackgroundColor
        self.view.addSubview(chosenVotes)
        chosenVotes.layer.cornerRadius = 10
        let votesWidth = CGFloat(percentageOfVotes)/100
        
        
        UIView.animate(withDuration: 2.0) {
            chosenVotes.frame = CGRect(x: 0, y: self.view.bounds.size.height/2-25, width: self.view.bounds.size.width * votesWidth, height: 50)
        }
        
        
        let votesPercentageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 50))
        votesPercentageLabel.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        votesPercentageLabel.textColor = .white
        votesPercentageLabel.font = votesPercentageLabel.font.withSize(20)
        votesPercentageLabel.textAlignment = .center
        votesPercentageLabel.text = "С вами согласны \(percentageOfVotes)% пользователей"
        self.view.addSubview(votesPercentageLabel)
        
        
        let timeWaitingToHide = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + timeWaitingToHide) {
            self.hideChosenVotes(votesBackground: otherVotes, chosenVotes: chosenVotes, backgroundColor: chosenOptionBackgroundColor, votesPercentageLabel: votesPercentageLabel, otherBackgroundColor: otherOptionBackgroundColor)
        }
    }
    
    //MARK: Hide votes animations
    func hideChosenVotes(votesBackground: UIView, chosenVotes: UIView, backgroundColor: UIColor, votesPercentageLabel: UILabel, otherBackgroundColor: UIColor) {
        UIView.animate(withDuration: 2.0) {
            votesBackground.backgroundColor = otherBackgroundColor.withAlphaComponent(0)
            chosenVotes.backgroundColor = backgroundColor.withAlphaComponent(0)
//            votesBackground.layer.borderColor = UIColor.white.withAlphaComponent(0.0).cgColor
//            votesBackground.layer.borderWidth = 0.0
            
            votesPercentageLabel.alpha = 0
        }
        print("Hiding the vote colors")
    }
    
}
