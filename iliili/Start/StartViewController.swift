//
//  StartViewController.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/8/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit
import MBProgressHUD

class StartViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    var interactor: StartInteractor?
       
    func setup() {
        let interactor = StartInteractor()
        self.interactor = interactor
        let presenter = StartPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
        startButton.addTarget(self,
                              action: #selector(startGame),
                              for: .touchUpInside)
    }
    
    @objc func startGame() {
        interactor?.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

//    func showLoading() {
//        print("now calling showLoading")
//        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
//        Indicator.label.text = "Загрузка"
//        Indicator.isUserInteractionEnabled = false
//        Indicator.detailsLabel.text = "Загружаем вопросы..."
//        Indicator.show(animated: true)
//    }
//    
//    func hideLoading() {
//        MBProgressHUD.hide(for: self.view, animated: true)
//    }
    
    func showNextScreen() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(identifier: "mainView") as! MainViewController
//            vc.questions = questions
            vc.start()
            vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(vc, animated:true, completion:nil)
        }
    }
}
