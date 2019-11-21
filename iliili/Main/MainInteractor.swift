//
//  MainInteractor.swift
//  iliili
//
//  Created by Viktor Gordienko on 11/7/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class MainInteractor {
    var presenter: MainPresenter?
    
    func getNewQuestion(questions: [Question]) {
        let options = questions.randomElement()
        presenter?.getNewQuestion(question: options!)
//        sendVote()
    }
//    
//    func sendVote() {
//        //TODO: send votes here
//                
////        here's what it looks like for the viewController:
////        option1.setTitle(question.options.option1, for: .normal)
////        option2.setTitle(question.options.option2, for: .normal)
//                
//            
////        Depending on the tag, send a vote
//    }
//    func buttonClicked(sender: UIButton) {
//        switch sender.tag {
//        case 1:
////            sender.isHidden = true //button1
//            print("1")
//            letsGetThatShitTogether()
//            break;
//        case 2:
////            sender.isHidden = true //button2
//            print("2")
//            break;
//        default: ()
//        break;
//        }
//    }
//    
//    
//    
//    
//
//    
//    func letsGetThatShitTogether() {
////        Database.database().reference().child("questions").observe(.value) { snapshot in
////          print(snapshot.childrenCount)
////        }
//        
//        Database.database().reference().child("questions").child("2").observe(.value) { snapshot in
//          print(snapshot.value)
//        }
//        
//        Database.database().reference().child("questions").child("2").child("options").child("option2votes").setValue(69)
//        
//    }
    
}
