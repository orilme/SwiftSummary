//
//  ConditionLockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/30.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class ConditionLockVC: UIViewController {

    var conditionArray = [String]()
    var myCondition = NSCondition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button1 = UIButton.init(frame: CGRect(x: 30, y: 100, width: 200, height: 100))
        button1.setTitle("nsConditio", for: .normal)
        button1.addTarget(self, action: #selector(nsCondition2), for: .touchUpInside)
        button1.backgroundColor = .red
        self.view.addSubview(button1)
        
        let button2 = UIButton.init(frame: CGRect(x: 30, y: 230, width: 200, height: 100))
        button2.setTitle("nsConditionLock", for: .normal)
        button2.addTarget(self, action: #selector(nsConditionLock), for: .touchUpInside)
        button2.backgroundColor = .darkGray
        self.view.addSubview(button2)
        
        nsCondition()
    }
    
    /*
      * lock: 一般用于多线程同时访问、修改同一个数据源，保证在同一时间内数据源只被访问、修改一次，其他线程的命令需要在lock 外等待，只到unlock ，才可访问
      * unlock: 与lock 同时使用
      * wait: 让当前线程处于等待状态
      * signal: CPU发信号告诉线程不用在等待，可以继续执行
      */
    func nsCondition() {
        let cjcondition = NSCondition()
        /// 在加上锁之后，调用条件对象的 wait 或 waitUntilDate: 方法来阻塞线程，直到条件对象发出唤醒信号或者超时之后，再进行之后的操作。
        DispatchQueue.global(qos: .default).async {
            cjcondition.lock()
            print("线程1线程加锁----NSTreat：", Thread.current)
            cjcondition.wait()
            print("线程1线程唤醒")
            cjcondition.unlock()
            print("线程1线程解锁")
        }
        
        DispatchQueue.global(qos: .default).async {
            cjcondition.lock()
            print("线程2线程加锁----NSTreat：", Thread.current)
            if cjcondition.wait(until: Date.init(timeIntervalSinceNow: 3)) {
                print("线程2线程唤醒")
                cjcondition.unlock()
                print("线程2线程解锁")
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            sleep(2)
            /*
                1、休眠时间如果超过了线程中条件锁等待的时间，那么所有的线程都不会被唤醒。不管是哪一个线程中设置的时间，都不能超时，否则就会返回NO，全部不执行！切记切记！
                2、一次只能唤醒一个线程，要调用多次才可以唤醒多个线程，如下调用两次，将休眠的两个线程解锁。
                3、唤醒的顺序为线程添加的顺序。
                */
            cjcondition.signal()
            //sleep(2)
            cjcondition.signal()
            
            /// 一次性全部唤醒
            //cjcondition.broadcast()
        }
    }
    
    @objc func nsCondition2() {
        DispatchQueue.global(qos: .default).async {
            self.myCondition.lock()
            if self.conditionArray.count == 0 {
                print("等待制作数组")
                self.myCondition.wait()
            }
            print("获取对象进行操作:---", self.conditionArray[0])
            self.myCondition.unlock()
        }
        
        DispatchQueue.global(qos: .default).async {
            self.myCondition.lock()
            self.conditionArray.append("哈哈哈")
            print("创建了一个对象: --- 哈哈哈")
            self.myCondition.signal()
            self.myCondition.unlock()
            print("走完了---")
        }
    }
    
    @objc func nsConditionLock() {
        let conditionLock = NSConditionLock()
        let arrayM = NSMutableArray()
        DispatchQueue.global(qos: .default).async {
            conditionLock.lock()
            for i in 0...6 {
                arrayM.add("\(i)")
                print("异步下载图片---", i)
                sleep(1)
                if arrayM.count == 4 {
                    conditionLock.unlock(withCondition: 4)
                }
            }
        }
        DispatchQueue.main.async {
            conditionLock.lock(whenCondition: 4)
            print("已经获取到4张图片->主线程渲染")
            conditionLock.unlock()
        }
    }
    
}
