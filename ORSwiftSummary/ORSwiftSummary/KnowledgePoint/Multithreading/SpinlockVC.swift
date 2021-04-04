//
//  SpinlockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/30.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class SpinlockVC: UIViewController {

    var unfairlock : os_unfair_lock_t?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        test_unfair_lock()
    }
    
    func test_unfair_lock() {
        NSLog("start")
        unfairlock = .allocate(capacity: 1)
        unfairlock?.initialize(to: os_unfair_lock())
        for i in 1...6 {
            DispatchQueue.global(qos: .default).async {
                os_unfair_lock_lock(self.unfairlock!)
                sleep(1)
                print("\(i):", Thread.current.description)
                os_unfair_lock_unlock(self.unfairlock!)
            }
        }
        //trylock
        DispatchQueue.global(qos: .default).async {
            if (os_unfair_lock_trylock(self.unfairlock!)) {
                sleep(1)
                print("trylock---", Thread.current.description);
                os_unfair_lock_unlock(self.unfairlock!)
            }
        }
        NSLog("end")
    }

}
