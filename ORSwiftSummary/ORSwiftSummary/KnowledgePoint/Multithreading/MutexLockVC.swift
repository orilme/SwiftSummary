//
//  MutexLockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/30.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class MutexLockVC: UIViewController {
    
    var lock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .green
        
        methodA()
    }
    
    func methodA() {
        lock.lock()
        print("1---")
        methodB()
        print("2---")
        lock.unlock()
    }
    
    func methodB() {
        lock.lock()
        print("3---")
        lock.unlock()
    }
    
}
