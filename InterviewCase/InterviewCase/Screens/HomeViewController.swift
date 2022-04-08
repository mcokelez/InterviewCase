//
//  HomeViewController.swift
//  InterviewCase
//
//  Created by Maviye Çökelez on 6.04.2022.
//

import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "MapViewController")
            destVC.modalPresentationStyle = .overCurrentContext
            destVC.modalTransitionStyle = .crossDissolve
            self.present(destVC, animated: false, completion: nil)
        }
    }
}

