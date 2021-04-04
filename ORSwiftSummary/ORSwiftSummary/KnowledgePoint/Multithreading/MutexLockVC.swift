//
//  MutexLockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/30.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class MutexLockVC: UIViewController {
    /// 设置车票总数为10
    var tickets : Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .green
        
        let thread1 = Thread(target: self,selector: #selector(saleTickets),object: nil)
        thread1.name = "thread-1"
        thread1.start()
        
        let thread2 = Thread(target: self,selector: #selector(saleTickets),object: nil)
        thread2.name = "thread-1"
        thread2.start()
    
        
    }
    
    @objc func saleTickets() {
//        let object = NSObject()
//        while true {
//            @synchronized(self) do {
//                Thread.sleep(forTimeInterval: 1)
//                if self.tickets > 0 {
//                    self.tickets = self.tickets - 1
//                    print("剩余票数---", self.tickets)
//                }else {
//                    print("票卖没了---", self.tickets)
//                }
//            }
//        }
    }
    

}
