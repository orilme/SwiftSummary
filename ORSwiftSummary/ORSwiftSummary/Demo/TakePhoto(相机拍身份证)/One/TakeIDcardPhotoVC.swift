//
//  TakeIDcardPhotoVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/27.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class TakeIDcardPhotoVC: UIViewController {
    
    lazy var showImageView: UIImageView = {
        let imageVWidth = UIScreen.WIDTH - 2 * 17
        let imageVHeight = imageVWidth * 234/342
        let view = UIImageView.init(frame: CGRect(x: 20, y: 200, width: imageVWidth - 40, height: imageVHeight - 44))
        view.backgroundColor = UIColor.red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let sureBtn = UIButton.init(frame: CGRect(x: 20, y: 100, width: 100, height: 50))
        sureBtn.backgroundColor = UIColor.green
        sureBtn.setTitle("去拍照", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        self.view.addSubview(sureBtn)
        
        self.view.addSubview(showImageView)
    }

    // MARK: Action
    @objc func takePhoto() {
        let takePictureVC = TakePictureVC()
        takePictureVC.modalPresentationStyle = .fullScreen
        takePictureVC.getImage = { [weak self] (image) in
            self?.showImageView.image = image
        }
        self.present(takePictureVC, animated: true, completion: nil)
    }
    
}
