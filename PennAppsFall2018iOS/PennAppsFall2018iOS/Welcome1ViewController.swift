//
//  Welcome1ViewController.swift
//  PennAppsFall2018iOS
//
//  Created by Justin May on 9/9/18.
//  Copyright © 2018 Justin May. All rights reserved.
//

import UIKit

class Welcome1ViewController: UIViewController {

    @IBOutlet weak var welcome1text: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.welcome1text.alpha = 0;
        self.welcome1text.faded(completion: {(finished:Bool) -> Void in self.welcome1text.fadeOut()})
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.performSegue(withIdentifier: "welcome1to2segue", sender: self)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension UIView {
    func faded(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
        
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.5, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
        
    }
    
}

