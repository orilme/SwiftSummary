//
//  AccessPhotoAlbumViewController.swift
//  UAgent
//
//  Created by GXYJ on 2019/3/20.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import UIKit

class AccessPhotoAlbumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let accessLabel = UILabel(frame: CGRect(x: 30, y: 50 + UIScreen.NAVHEIGHT, width: UIScreen.WIDTH - 60, height: 50))
        accessLabel.textAlignment = .center
        accessLabel.numberOfLines = 0
        accessLabel.text = "请在iPhone的“设置-隐私-照片”选项中，允许访问你的手机相册。"
        view.addSubview(accessLabel)
    }
}
