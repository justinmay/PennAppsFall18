//
//  Welcome3ViewController.swift
//  PennAppsFall2018iOS
//
//  Created by Justin May on 9/9/18.
//  Copyright © 2018 Justin May. All rights reserved.
//

import UIKit

class Welcome3ViewController: UIViewController {

    @IBOutlet weak var welcome3text: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.welcome3text.alpha = 0;
        self.welcome3text.faded(completion: {(finished:Bool) -> Void in self.welcome3text.fadeOut()})
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.performSegue(withIdentifier: "welcome3to4segue", sender: self)
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
