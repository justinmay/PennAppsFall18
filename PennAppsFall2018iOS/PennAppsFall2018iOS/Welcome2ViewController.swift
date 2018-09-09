//
//  Welcome2ViewController.swift
//  PennAppsFall2018iOS
//
//  Created by Justin May on 9/9/18.
//  Copyright © 2018 Justin May. All rights reserved.
//

import UIKit

class Welcome2ViewController: UIViewController {

    @IBOutlet weak var welcome2text: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.welcome2text.alpha = 0;
        self.welcome2text.faded(completion: {(finished:Bool) -> Void in self.welcome2text.fadeOut()})
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.performSegue(withIdentifier: "welcome2to3segue", sender: self)
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
