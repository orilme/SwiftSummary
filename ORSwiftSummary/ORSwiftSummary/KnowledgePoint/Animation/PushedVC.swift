//
//  PushedVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/18.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class PushedVC: UIViewController {
    
    //动画过渡转场
    var transitionAnimation = CustomPush()
    
    var imageView = UIImageView()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .green
        self.title = "转场动画"
        
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: UIScreen.WIDTH, height: 200))
        imageView.image = UIImage(named: "img_back")
        imageView.backgroundColor = .red
        self.view.addSubview(imageView)
        

    }
    
    
}
