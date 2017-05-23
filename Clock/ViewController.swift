//
//  ViewController.swift
//  Clock
//
//  Created by Tan Vu on 5/22/17.
//  Copyright © 2017 Tan Vu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var clockView = ClockView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(clockView)
        clockView.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height)
        clockView.backgroundColor = .white
    }
    
}

