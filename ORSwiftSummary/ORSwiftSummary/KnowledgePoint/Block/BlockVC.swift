//
//  BlockVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/8/27.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class BlockVC: UIViewController {

    var count : Int = 0
    
    public var testBlock:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
//            self.testBlock = {
//            print("BlockVC---2")
//            self.count = 0
//        }
        
        testBlock = { [weak self] in
            print("BlockVC---2")
            self?.count = 0
        }
        
        print("BlockVC---1")
        testBlock?()
        
    }
    
    deinit {
        print("deinit---BlockVC")
    }

}
