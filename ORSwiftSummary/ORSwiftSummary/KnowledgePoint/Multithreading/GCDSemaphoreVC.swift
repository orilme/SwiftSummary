//
//  GCDSemaphoreVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/3/28.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class GCDSemaphoreVC: UIViewController {
    
    let alertQueue = DispatchQueue(label: "GCDSemaphoreVC")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        demo()
        //showSequenceAlert()
    }
    
    func demo() {
        var array = ["李","李","李","李","李"]
        //这是正确的，下面的第二个是错误的。应该先枚举在倒序
        for (n,s) in array.enumerated().reversed(){
            print("\(n)\(s)")
            if s == "李" {
                array.remove(at: n)
            }
        }
        print(array)
        //这是错误的
        //for (n,s) in array.reversed().enumerated(){
        //    print("\(n)\(s)")
        //}
    }

    func showSequenceAlert() {
        print("Thread--------", Thread.current);
        alertQueue.async {
            print("1---------------------1");
            let sema = DispatchSemaphore(value: 0)
            print("1---------------------2");
            DispatchQueue.main.async {
                print("Thread--------", Thread.current);
                print("1---------------------3");
                let alertController = UIAlertController(title: "提示", message: "11111111111", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                    sema.signal();
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            print("2---------------------1");
            sema.wait()
            print("2---------------------2");
            DispatchQueue.main.async {
                print("Thread--------", Thread.current);
                print("2---------------------3");
                let alertController = UIAlertController(title: "提示", message: "222222222", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                    sema.signal();
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            print("3---------------------1");
            sema.wait()
            print("3---------------------2");
            DispatchQueue.main.async {
                print("Thread--------", Thread.current);
                print("3---------------------3");
                let alertController = UIAlertController(title: "提示", message: "3333333", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                    sema.signal();
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
}
