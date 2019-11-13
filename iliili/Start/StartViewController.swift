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

    //TODO: fix loading spinner
    func showLoading() {
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.label.text = "Indicator"
        Indicator.isUserInteractionEnabled = false
        Indicator.detailsLabel.text = "fetching details"
        Indicator.show(animated: true)
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showNextScreen(questions: [Question]) {
        let vc = self.storyboard?.instantiateViewController(identifier: "mainView") as! MainViewController
        vc.questions = questions
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated:true, completion:nil)
    }
}



//MARK: The old way of showing loading jsut in case

//var vSpinner : UIView?

//func showLoading(onView : UIView) {
//    print("trying to show loading")
//    let spinnerView = UIView.init(frame: onView.bounds)
//    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//    let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
//    ai.startAnimating()
//    ai.center = spinnerView.center
//
//    DispatchQueue.main.async {
//        spinnerView.addSubview(ai)
//        onView.addSubview(spinnerView)
//    }
//
//    vSpinner = spinnerView
//}
//
//func hideLoading() {
//    DispatchQueue.main.async {
//        self.vSpinner?.removeFromSuperview()
//        self.vSpinner = nil
//    }
//}
