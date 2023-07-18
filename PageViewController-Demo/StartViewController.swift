//
//  ViewController.swift
//  PageViewController-Demo
//
//  Created by JINSEOK on 2023/07/17.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
    
    func checkTutorialRun() {
        let userDefault = UserDefaults.standard
        if userDefault.bool(forKey: "Tutorial") == false {
            let tutorialVC = TutorialViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            tutorialVC.modalPresentationStyle = .fullScreen
            present(tutorialVC, animated: false)
        }
    }
}

