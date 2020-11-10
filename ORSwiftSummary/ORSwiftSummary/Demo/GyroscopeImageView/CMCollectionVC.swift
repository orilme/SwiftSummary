//
//  CMCollectionVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/10/16.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class CMCollectionVC: UIViewController, UIScrollViewDelegate {
    
    private lazy var previewView: MultimediaPreviewView = {
        let previewView = MultimediaPreviewView(frame: CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: kMultimediaPreviewViewHeight))
        return previewView
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
    
    lazy var vrLabel: UILabel = {
        let label = UILabel()
        label.text = "下拉进入VR"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        scrollView.backgroundColor = .purple
        view.addSubview(scrollView)
        
        scrollView.addSubview(previewView)
        
        vrLabel.frame = CGRect(x: UIScreen.WIDTH/2 - 50, y: UIScreen.SafeAreaInsetsTop, width: 100, height: 40)
        previewView.addSubview(vrLabel)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            print("scrollViewDidScroll---", offsetY)
            vrLabel.isHidden = offsetY > -50
            self.previewView.mj_y = offsetY
            self.previewView.mj_h = abs(offsetY) + kMultimediaPreviewViewHeight
        }
           
        if offsetY < -kMultimediaPreviewViewHeight / 2 {
            vrLabel.text = "欢迎进入VR"
        }else {
            vrLabel.text = "下拉进入VR"
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView.contentOffset.y < -kMultimediaPreviewViewHeight / 2 else { return }
        self.vrLabel.isHidden = true
        self.navigationController?.pushViewController(CMCollectionVC(), animated: true)
        self.previewView.mj_y = 0
        self.previewView.mj_h = kMultimediaPreviewViewHeight
        //self.previewView.collectionView.layoutIfNeeded()
        self.previewView.collectionView.reloadData()
        print("pushViewController---")
    }
    
}
