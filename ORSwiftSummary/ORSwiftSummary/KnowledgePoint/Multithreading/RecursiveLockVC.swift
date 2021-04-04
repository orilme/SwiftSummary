//
//  RecursiveLockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/31.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class RecursiveLockVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button1 = UIButton.init(frame: CGRect(x: 30, y: 100, width: 200, height: 100))
        button1.setTitle("RecursiveLock", for: .normal)
        button1.addTarget(self, action: #selector(testNSRecursiveLock), for: .touchUpInside)
        button1.backgroundColor = .red
        self.view.addSubview(button1)
        
        let button2 = UIButton.init(frame: CGRect(x: 30, y: 230, width: 200, height: 100))
        button2.setTitle("NSLock", for: .normal)
        button2.addTarget(self, action: #selector(testNSLock), for: .touchUpInside)
        button2.backgroundColor = .darkGray
        self.view.addSubview(button2)
    }
    
    @objc func testNSRecursiveLock() {
        /// 如果使用_lock会招致死锁，因为被同一个线程多次调用。每次进入这个block时，都会去加一次锁，而从第二次开始，由于锁已经被使用了且没有解锁，所以它需要等待锁被解除，这样就导致了死锁，线程被阻塞住了。
        let lock = NSRecursiveLock()
        DispatchQueue.global(qos: .default).async {
            var recursiveMethod: ((_ type: Int)->Void)?
            recursiveMethod = { (value) in
                lock.lock()
                if (value > 0) {
                    print("value = ", value)
                    sleep(1);
                    recursiveMethod!(value - 1);
                }
                lock.unlock()
            }
            recursiveMethod!(5) //方法内部判断来执行5次
        }
    }
    
    @objc func testNSLock() {
        let lock = NSLock()
        DispatchQueue.global(qos: .default).async {
            var recursiveMethod: ((_ type: Int)->Void)?
            recursiveMethod = { (value) in
                lock.lock()
                if (value > 0) {
                    print("value = ", value)
                    sleep(1);
                    recursiveMethod!(value - 1);
                }
                lock.unlock()
            }
            recursiveMethod!(5) //方法内部判断来执行5次
        }
    }
    

}
