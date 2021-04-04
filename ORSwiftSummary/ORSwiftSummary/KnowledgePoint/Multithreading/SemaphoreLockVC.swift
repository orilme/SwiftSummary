//
//  SemaphoreLockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/30.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class SemaphoreLockVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testDispatch_semaphore()
    }
    

    /* 1、dispatch_semaphore 和 NSCondition 类似，都是一种基于信号的同步方式，但 NSCondition 信号只能发送，不能保存（如果没有线程在等待，则发送的信号会失效）。而 dispatch_semaphore 能保存发送的信号。dispatch_semaphore 的核心是 dispatch_semaphore_t 类型的信号量。
      * 2、dispatch_semaphore_create(1) 方法可以创建一个 dispatch_semaphore_t （ 英  ['seməfɔː]）类型的信号量，设定信号量的初始值为 1。注意，这里的传入的参数必须大于或等于 0，否则 dispatch_semaphore_create 会返回 NULL。
      * 3、dispatch_semaphore_wait(semaphore, overTime); 方法会判断 semaphore 的信号值是否大于 0。大于 0 不会阻塞线程，消耗掉一个信号，执行后续任务。如果信号值为 0，该线程会和 NSCondition 一样直接进入 waiting状态，等待其他线程发送信号唤醒该线程执行后续任务，或者当 overTime 时限到了，也会执行后续任务。
      * 4、dispatch_semaphore_signal(semaphore); 发送信号，如果没有等待的线程接受信号，则使 signal 信号值加一（做到对信号的保存）。
      * 5、一个 dispatch_semaphore_wait(semaphore, overTime); 方法会去对应一个 dispatch_semaphore_signal(semaphore); 看起来像 NSLock 的 lock 和 unlock，其实可以这样理解，区别只在于有信号量这个参数，，lock unlock 只能同一时间，只能有一个线程访问被保护的临界区，而如果信号量参数初始值为 x，那么就会有 x 个线程可以同时访问被保护的临界区。
      */
    
    func testDispatch_semaphore() {
        let semaphore = DispatchSemaphore(value: 1)
        let overTime = DispatchTime.now() + 3 // overTime
        DispatchQueue.global(qos: .default).async {
            print("线程1---1")
            let result = semaphore.wait(timeout: overTime)
            print("线程1---2")
            sleep(5)
            semaphore.signal()
            print("线程1---3", result)
        }
        
        DispatchQueue.global(qos: .default).async {
            print("线程2---1")
            sleep(1)
            let result = semaphore.wait(timeout: overTime)
            print("线程2---2");
            semaphore.signal()
            print("线程2---3", result);
        }
        
        DispatchQueue.global(qos: .default).async {
            print("线程3---1")
            sleep(1)
            let result = semaphore.wait(timeout: overTime)
            print("线程3---2")
            semaphore.signal()
            print("线程3---3", result)
        }
    }
}
