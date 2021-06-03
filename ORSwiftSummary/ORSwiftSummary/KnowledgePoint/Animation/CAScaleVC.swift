//
//  CAScaleVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/5/6.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

class CAScaleVC: UIViewController {

    var contianerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let itemH = UIScreen.HEIGHT  - UIScreen.IPHONXSafeBottom - UIScreen.NAVHEIGHT
        let scrollView1 = UIScrollView(frame: CGRect(x: 0, y: UIScreen.NAVHEIGHT, width: UIScreen.WIDTH, height: itemH))
        scrollView1.backgroundColor = .green
        //scrollView1.delegate = self
        scrollView1.isScrollEnabled = true
        scrollView1.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView1)
        scrollView1.contentSize = CGSize(width: 0, height: itemH + 100)
        
        contianerView = UIView(frame: CGRect(x: 12, y: 20, width: 351, height: 719))
        contianerView.backgroundColor = .red
        scrollView1.addSubview(contianerView)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 351, height: 719))
        imageView.image = UIImage(named: "ps_bg_vr")
        imageView.backgroundColor = .red
        contianerView.addSubview(imageView)
        
        
        let houseView1 = UIView(frame: CGRect(x: 12, y: 174, width: 327, height: 390))
        houseView1.backgroundColor = .blue
        contianerView.addSubview(houseView1)
        
        let headView = UIImageView(frame: CGRect(x: 20, y: 630, width: 58, height: 58))
        headView.backgroundColor = .blue
        contianerView.addSubview(headView)
        
        let titleLabel = UILabel(frame: CGRect(x: 100, y: 630, width: 100, height: 20))
        titleLabel.text = "看的撒来得快撒了"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        contianerView.addSubview(titleLabel)
        
        
        let scale : CGFloat = (UIScreen.WIDTH - 40) / 351
        
        let y : CGFloat = 715 * scale / 2 + 20
        
        let group = CAAnimationGroup()
        
        let animationX = CABasicAnimation()
        animationX.keyPath = "position"
        animationX.toValue = NSValue(cgPoint: CGPoint(x: UIScreen.WIDTH/2, y: y))
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.scale"
        animation.toValue = scale
        
        group.animations = [animationX, animation]
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        self.contianerView.layer.add(group, forKey: nil)
        
    }
    

}
