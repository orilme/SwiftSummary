//
//  CABasicAnimationVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/5/6.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class CABasicAnimationVC: UIViewController {

    var contianerView = UIView()
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        contianerView = UIView(frame: CGRect(x: 10, y: 100, width: 300, height: 200))
        contianerView.backgroundColor = .red
        self.view.addSubview(contianerView)
        
        imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 200, height: 100))
        imageView.image = UIImage(named: "img_back")
        contianerView.addSubview(imageView)
        
  
        let sureBtn = UIButton.init(frame: CGRect(x: 100, y: 600, width: 100, height: 100))
        sureBtn.setTitle("开始", for: .normal)
        sureBtn.addTarget(self, action: #selector(pushVC(btn:)), for: .touchUpInside)
        sureBtn.backgroundColor = .red
        self.view.addSubview(sureBtn)
        
    }
    
    @objc func pushVC(btn : UIButton) {
//        contianerView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
//
//        let animation = CABasicAnimation()
//        animation.keyPath = "transform.scale"
//        animation.toValue = 0.5
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = .forwards
//        self.contianerView.layer.add(animation, forKey: nil)
//
//        contianerView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let group = CAAnimationGroup()

        let animationX = CABasicAnimation()
        animationX.keyPath = "position"
        animationX.toValue = NSValue(cgPoint: CGPoint(x: 160, y: 150))

        let animation = CABasicAnimation()
        animation.keyPath = "transform.scale"
        animation.toValue = 0.5

        group.animations = [animationX, animation]
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        self.contianerView.layer.add(group, forKey: nil)
    }

}
