//
//  ViewController.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/6/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var iliLabel: UILabel!
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBAction func option1(_ sender: UIButton) {
        animateButton(sender, rotationAngle: 69)
        interactor?.choseOption1(chosenOption: option1, otherOption: option2)
    }
    @IBAction func option2(_ sender: UIButton) {
        animateButton(sender, rotationAngle: -69)
        interactor?.choseOption2(chosenOption: option2, otherOption: option1)
    }
    
    var interactor: MainInteractor?
    
    func start() {
        interactor?.initQuestion()
    }
    
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
        
        interactor!.initQuestion()
    }
    
    func showNewQuestionOnButtonLabels(question: Question) {
        option1.setTitle(question.options.option1, for: .normal)
        option2.setTitle(question.options.option2, for: .normal)
    }
    
    //MARK: Loading
    func showLoading() {
        print("now calling showLoading")
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.label.text = "Загрузка"
        Indicator.isUserInteractionEnabled = false
        Indicator.detailsLabel.text = "Загружаем вопросы..."
        Indicator.show(animated: true)
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
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
    //MARK: Hiding "ИЛИ"
    func hideIliLabel() {
        UILabel.animate(withDuration: 1.0) {
            self.iliLabel.alpha = 0
        }
    }
    
    
    //MARK: Show votes animations
    func showVotesAnimation(percentageOfVotes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor, optionVotesTag: String) {
        
        let votesWidth = CGFloat(percentageOfVotes)/100
        
        let otherVotes = UIView(frame: CGRect(x: 0,
                                              y: self.view.bounds.size.height/2-25,
                                              width: self.view.bounds.size.width,
                                              height: 50))
        otherVotes.backgroundColor = otherOptionBackgroundColor
        self.view.addSubview(otherVotes)
        otherVotes.layer.cornerRadius = 10
        otherVotes.layer.borderWidth = 0.5
        otherVotes.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        
        let chosenVotes = UIView(frame: CGRect(x: 0,
                                               y: self.view.bounds.size.height/2-25,
                                               width: 0,
                                               height: 50))
        
        chosenVotes.backgroundColor = chosenOptionBackgroundColor
        self.view.addSubview(chosenVotes)
        chosenVotes.layer.cornerRadius = 10
        chosenVotes.layer.borderWidth = 0.5
        chosenVotes.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        
        
        animate1(chosenVotes: chosenVotes, votesWidth: votesWidth)
        
        
        let votesPercentageLabel = UILabel(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: self.view.bounds.size.width,
                                                         height: 50))
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
    
    func showVotesAnimation2(percentageOfVotes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor, optionVotesTag: String) {
        
        let votesWidth = CGFloat(percentageOfVotes)/100
        
        let otherVotes = UIView(frame: CGRect(x: 0,
                                              y: self.view.bounds.size.height/2-25,
                                              width: self.view.bounds.size.width,
                                              height: 50))
        otherVotes.backgroundColor = otherOptionBackgroundColor
        self.view.addSubview(otherVotes)
        otherVotes.layer.cornerRadius = 10
        otherVotes.layer.borderWidth = 0.5
        otherVotes.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        
        let chosenVotes = UIView(frame: CGRect(x: self.view.bounds.size.width,
                                               y: self.view.bounds.size.height/2-25,
                                               width: 0,
                                               height: 50))
        
        chosenVotes.backgroundColor = chosenOptionBackgroundColor
        self.view.addSubview(chosenVotes)
        chosenVotes.layer.cornerRadius = 10
        chosenVotes.layer.borderWidth = 0.5
        chosenVotes.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        
        
        animate2(chosenVotes: chosenVotes, votesWidth: votesWidth)
        
        
        let votesPercentageLabel = UILabel(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: self.view.bounds.size.width,
                                                         height: 50))
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
    
    func animate1(chosenVotes: UIView, votesWidth: CGFloat) {
        UIView.animate(withDuration: 2.0) {
            chosenVotes.frame = CGRect(x: 0,
                                       y: self.view.bounds.size.height/2-25,
                                       width: self.view.bounds.size.width * votesWidth,
                                       height: 50)
        }
    }
    func animate2(chosenVotes: UIView, votesWidth: CGFloat) {
        UIView.animate(withDuration: 2.0) {
            chosenVotes.frame = CGRect(x: self.view.bounds.size.width * (1 - votesWidth),
                                       y: self.view.bounds.size.height/2-25,
                                       width: self.view.bounds.size.width * votesWidth,
                                       height: 50)
        }
    }
    
    
    //MARK: Hide votes animations
    func hideChosenVotes(votesBackground: UIView, chosenVotes: UIView, backgroundColor: UIColor, votesPercentageLabel: UILabel, otherBackgroundColor: UIColor) {
        UIView.animate(withDuration: 2.0) {
            votesBackground.backgroundColor = otherBackgroundColor.withAlphaComponent(0)
            chosenVotes.backgroundColor = backgroundColor.withAlphaComponent(0)
            votesBackground.layer.borderColor = UIColor.white.withAlphaComponent(0.0).cgColor
            votesBackground.layer.borderWidth = 0.0
            

            chosenVotes.layer.borderWidth = 0.0
            
            votesPercentageLabel.alpha = 0
        }
        print("Hiding the vote colors")
    }
    
}
