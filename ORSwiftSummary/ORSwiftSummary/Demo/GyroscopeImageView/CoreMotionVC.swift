//
//  CoreMotionVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/10/16.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class CoreMotionVC: UIViewController, UIScrollViewDelegate {
    
    private lazy var imageView: GyroscopeImageView = {
        let imageView = GyroscopeImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: 300)
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: UIScreen.NAVHEIGHT, width: UIScreen.WIDTH, height: UIScreen.HEIGHT - UIScreen.NAVHEIGHT)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        scrollView.backgroundColor = .purple
        view.addSubview(scrollView)
        
        
        imageView.backgroundColor = .red
        imageView.moveImgView.image = UIImage.init(named: "img_back")
        scrollView.addSubview(imageView)
        imageView.setMoveImgViewFrame(width: UIScreen.WIDTH, height: 300)
        
        let selectBtn = UIButton.init(frame: CGRect(x: 60, y: 400, width: 100, height: 50))
        selectBtn.setTitle("下一页", for: .normal)
        selectBtn.backgroundColor = UIColor.purple
        selectBtn.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)
        scrollView.addSubview(selectBtn)

    }
    
    @objc func openPhotoAlbum() {
        let vc = CoreMotionVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("sss====", imageView.frame)
        imageView.frame.size.height = 300 + abs(offsetY)
        imageView.frame.size.width = (300 + abs(offsetY)) * (UIScreen.WIDTH / 300)
        imageView.center = CGPoint(x: UIScreen.WIDTH/2, y: 150)
        print("sss====2", imageView.frame)
    }
    
}
