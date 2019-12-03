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
        option1.titleLabel?.textAlignment = .center
        animateButton(sender, rotationAngle: 69)
        interactor?.chooseOption1(chosenOption: option1, otherOption: option2)
    }
    @IBAction func option2(_ sender: UIButton) {
        option2.titleLabel?.textAlignment = .center
        animateButton(sender, rotationAngle: -69)
        interactor?.chooseOption2(chosenOption: option2, otherOption: option1)
    }
    
    func showNewQuestionOnButtonLabels(question: Question) {
        option1.setTitle(question.options.option1, for: .normal)
        option2.setTitle(question.options.option2, for: .normal)
    }
    
    var interactor: MainInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initQuestion()
    }
    
    func setup() {
        let interactor = MainInteractor()
        self.interactor = interactor
        let presenter = MainPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    func initQuestion() {
        interactor?.initQuestion()
    }
    
    //MARK: Loading view
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
    
    func hideIliLabel() {
        UILabel.animate(withDuration: 1.0) {
            self.iliLabel.alpha = 0
        }
    }
    
    //MARK: showVotesAnimation
    func showVotesAnimation(percentageOfVotes: Int, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor, chosenVotesXPoint: CGFloat, chosenVotesXPointAnimate: CGFloat) {
        let votesWidth = CGFloat(percentageOfVotes)/100
        let otherVotes = UIView(frame: CGRect(x: 0,
                                              y: self.view.bounds.size.height/2-25,
                                              width: self.view.bounds.size.width,
                                              height: 50))
        let chosenVotes = UIView(frame: CGRect(x: chosenVotesXPoint,
                                               y: self.view.bounds.size.height/2-25,
                                               width: 0,
                                               height: 50))
        let votesPercentageLabel = UILabel(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: self.view.bounds.size.width,
                                                         height: 50))
        addOtherVotesViewProperties(otherVotes: otherVotes, otherOptionBackgroundColor: otherOptionBackgroundColor)
        addChosenVotesViewProperties(chosenVotes: chosenVotes, chosenOptionBackgroundColor: chosenOptionBackgroundColor)
        addVotesPercentageLabelProperties(votesPercentageLabel: votesPercentageLabel, percentageOfVotes: percentageOfVotes)

        UIView.animate(withDuration: 2.0) {
            chosenVotes.frame = CGRect(x: chosenVotesXPointAnimate,
                                       y: self.view.bounds.size.height/2-25,
                                       width: self.view.bounds.size.width * votesWidth,
                                       height: 50)
        }
        
        hideVotes(chosenVotes: chosenVotes, otherVotes: otherVotes, chosenOptionBackgroundColor: chosenOptionBackgroundColor, otherOptionBackgroundColor: otherOptionBackgroundColor, votesPercentageLabel: votesPercentageLabel)
    }
    
    func addOtherVotesViewProperties(otherVotes: UIView, otherOptionBackgroundColor: UIColor) {
        otherVotes.backgroundColor = otherOptionBackgroundColor
        self.view.addSubview(otherVotes)
        otherVotes.layer.cornerRadius = 10
        otherVotes.layer.borderWidth = 0.3
        otherVotes.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
    }
    
    func addChosenVotesViewProperties(chosenVotes: UIView, chosenOptionBackgroundColor: UIColor) {
        chosenVotes.backgroundColor = chosenOptionBackgroundColor
        self.view.addSubview(chosenVotes)
        chosenVotes.layer.cornerRadius = 10
        chosenVotes.layer.borderWidth = 0.3
        chosenVotes.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
    }
    
    func addVotesPercentageLabelProperties(votesPercentageLabel: UILabel, percentageOfVotes: Int) {
        votesPercentageLabel.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        votesPercentageLabel.textColor = .white
        votesPercentageLabel.font = votesPercentageLabel.font.withSize(20)
        votesPercentageLabel.textAlignment = .center
        votesPercentageLabel.text = "С вами согласны \(percentageOfVotes)% пользователей"
        self.view.addSubview(votesPercentageLabel)
    }
    
    //MARK: Hide votes animations
    func hideVotes(chosenVotes: UIView, otherVotes: UIView, chosenOptionBackgroundColor: UIColor, otherOptionBackgroundColor: UIColor, votesPercentageLabel: UILabel) {
        let timeWaitingToHide = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + timeWaitingToHide) {
            UIView.animate(withDuration: 2.0) {
                votesPercentageLabel.alpha = 0
                otherVotes.layer.opacity = 0.0
                chosenVotes.layer.opacity = 0.0
            }
            print("Hiding the vote colors")
        }
    }
    
}
