//
//  AnimationViewController.swift
//  InterviewCase
//
//  Created by Maviye Çökelez on 7.04.2022.
//

import UIKit

class AnimationViewController: UIViewController {
    
    
    @IBOutlet weak var animationViewButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        animationViewButton.layer.cornerRadius = 80
        animationViewButton.layer.masksToBounds = true
        self.animate()
    }
    
    func animate(){
        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.animationViewButton.transform = scale
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.animationViewButton.transform = .identity
        }, completion: { done in
            if done {
                self.animateCircle()
            }
        })
    }
    
    func animateCircle() {
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        self.animationViewButton.transform = scale
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.animationViewButton.transform = .identity
        }, completion: { done in
            if done {
                self.animate()
            }
        })
    }
}
