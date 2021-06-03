//
//  RWLockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/30.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class RWLockVC: UIViewController {
    
    var tickets = 1
    var tickets2 = 1
    var queue = DispatchQueue(label: "DispatchQueue_read")
    
    var rwlock = pthread_rwlock_t()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .green
        let button1 = UIButton.init(frame: CGRect(x: 30, y: 100, width: 200, height: 100))
        button1.setTitle("读写锁(pthread_rwlock_t)", for: .normal)
        button1.addTarget(self, action: #selector(rwlockTest), for: .touchUpInside)
        button1.backgroundColor = .red
        self.view.addSubview(button1)
        
        let button2 = UIButton.init(frame: CGRect(x: 30, y: 230, width: 200, height: 100))
        button2.setTitle("读写锁(dispatch_barrier_async)", for: .normal)
        button2.addTarget(self, action: #selector(readWriteTest), for: .touchUpInside)
        button2.backgroundColor = .darkGray
        self.view.addSubview(button2)
        
        let button3 = UIButton.init(frame: CGRect(x: 30, y: 350, width: 200, height: 100))
        button3.setTitle("BarrierAsync", for: .normal)
        button3.addTarget(self, action: #selector(testBarrierAsync), for: .touchUpInside)
        button3.backgroundColor = .purple
        self.view.addSubview(button3)
        
        let button4 = UIButton.init(frame: CGRect(x: 30, y: 470, width: 200, height: 100))
        button4.setTitle("BarrierSync", for: .normal)
        button4.addTarget(self, action: #selector(testBarrierSync), for: .touchUpInside)
        button4.backgroundColor = .purple
        self.view.addSubview(button4)
        
        pthread_rwlock_init(&rwlock, nil)
        
    }
    
    //  pthread_rwlock_t 读写锁-----------------------------
    @objc func rwlockTest() {
        for _ in 1...10 {
            DispatchQueue.global(qos: .default).async {
                self.readrwTicket()
            }
            DispatchQueue.global(qos: .default).async {
                self.writereTicket()
            }
        }
    }
    
    func readrwTicket() {
        pthread_rwlock_rdlock(&rwlock)
        /// 读操作
        print("rwlock---read---", self.tickets2)
        pthread_rwlock_unlock(&rwlock)
    }
    
    func writereTicket() {
        pthread_rwlock_wrlock(&rwlock);
        /// 写操作
        self.tickets2 = self.tickets2 + 1
        print("rwlock---write---", self.tickets2)
        pthread_rwlock_unlock(&rwlock);
    }
    
    // dispatch_barrier_async / dispatch_barrier_sync 读写锁-----------------------------
    @objc func readWriteTest() {
        for _ in 1...30 {
            DispatchQueue.global(qos: .default).async {
                self.readTicket()
            }
            DispatchQueue.global(qos: .default).async {
                self.writeTicket()
            }
        }
    }
    
    func readTicket() {
        self.queue.async() {
            print("read---", self.tickets)
        }
    }
    
    func writeTicket() {
        self.queue.async(flags: .barrier) {
            self.tickets = self.tickets + 1
            print("write---", self.tickets)
        }
    }
    
    
    // dispatch_barrier_async / dispatch_barrier_sync -----------------------------
    @objc func testBarrierAsync() {
        let queue1 = DispatchQueue(label: "DispatchQueue_async")
        queue1.async {
            print("任务1---", Thread.current)
        }
        queue1.async {
            print("任务2---", Thread.current)
        }
        queue1.async {
            print("任务3---", Thread.current)
        }
        queue1.async(flags: .barrier) {
            print("任务barrier---", Thread.current)
            for i in 1...40 {
                print("任务barrier---\(i)---", Thread.current)
            }
        }
        queue1.async {
            print("任务4---", Thread.current)
        }
        queue1.async {
            print("任务5---", Thread.current)
        }
        queue1.async {
            print("任务6---", Thread.current)
        }
    }
    
    @objc func testBarrierSync() {
        let queue1 = DispatchQueue(label: "DispatchQueue_sync")
        queue1.async {
            print("sync---任务1---", Thread.current)
        }
        queue1.async {
            print("sync---任务2---", Thread.current)
        }
        queue1.async {
            print("sync---任务3---", Thread.current)
        }
        queue1.async(flags: .barrier) {
            print("sync---任务barrier---", Thread.current)
            for i in 1...40 {
                print("sync---任务barrier---\(i)---", Thread.current)
            }
        }
        queue1.async {
            print("sync---任务4---", Thread.current)
        }
        queue1.async {
            print("sync---任务5---", Thread.current)
        }
        queue1.async {
            print("sync---任务6---", Thread.current)
        }
    }
    

}
