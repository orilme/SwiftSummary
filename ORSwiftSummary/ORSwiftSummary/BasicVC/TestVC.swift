//
//  TestVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/5/29.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class TestVC: UIViewController {
    
    let commmomView = UIView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
    let oneView = UIView(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
    let twoView = UIView(frame: CGRect(x: 10, y: 250, width: 100, height: 100))
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        commmomView.backgroundColor = .green
        
        
        
        oneView.backgroundColor = .red
        self.view.addSubview(oneView)
        
        
        twoView.backgroundColor = .yellow
        self.view.addSubview(twoView)
        
        
        let sureBtn = UIButton.init(frame: CGRect(x: 10, y: 400, width: 100, height: 100))
        sureBtn.setTitle("开始", for: .normal)
        sureBtn.addTarget(self, action: #selector(pushVC(btn:)), for: .touchUpInside)
        sureBtn.backgroundColor = .brown
        self.view.addSubview(sureBtn)
    }
    
    @objc func pushVC(btn : UIButton) {
        print("ssss----------------")
//        commmomView.backgroundColor = .blue
//        if index == 0 {
//            index = 1
//            twoView.addSubview(commmomView)
//        }else {
//            index = 0
//            oneView.addSubview(commmomView)
//        }
        
        QRCodeModule().show(controller: self)
    }
    
    

}
