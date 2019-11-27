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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startButton.addTarget(self,
                              action: #selector(startGame),
                              for: .touchUpInside)
    }
       
    func setup() {
        let interactor = StartInteractor()
        self.interactor = interactor
        let presenter = StartPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    @objc func startGame() {
        interactor?.start()
    }
    
    func showNextScreen() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(identifier: "mainView") as! MainViewController
            vc.start()
            vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(vc, animated:true, completion:nil)
        }
    }
}
