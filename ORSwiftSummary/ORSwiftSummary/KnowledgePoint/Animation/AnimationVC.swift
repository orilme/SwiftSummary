//
//  AnimationVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/25.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class AnimationVC: UIViewController {
    
    var imageView = UIImageView()
    var imageView2 = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: UIScreen.WIDTH, height: 200))
        imageView.image = UIImage(named: "img_back")
        imageView.alpha = 0
        self.view.addSubview(imageView)
        
        
        imageView2 = UIImageView(frame: CGRect(x: 0, y: 500, width: UIScreen.WIDTH*0.2, height: 200*0.2))
        imageView2.image = UIImage(named: "img_back")
        self.view.addSubview(imageView2)
        
        
        
        let sureBtn = UIButton.init(frame: CGRect(x: 300, y: 500, width: 100, height: 100))
        sureBtn.setTitle("开始", for: .normal)
        sureBtn.addTarget(self, action: #selector(pushVC(btn:)), for: .touchUpInside)
        sureBtn.backgroundColor = .red
        self.view.addSubview(sureBtn)
    }
    
    @objc func pushVC(btn : UIButton) {
        UIView.animate(withDuration: 2, animations: {
            self.imageView2.frame = CGRect(x: 0, y: 100, width: UIScreen.WIDTH, height: 200)
        }) { (finished) in
            self.imageView2.removeFromSuperview()
            self.imageView.alpha = 1
        }
    }
    

}
