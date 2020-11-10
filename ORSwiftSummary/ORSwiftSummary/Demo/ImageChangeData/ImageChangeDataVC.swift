//
//  ImageChangeDataVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/4.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class ImageChangeDataVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let image = UIImage(named: "longbig")
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 80, width: UIScreen.WIDTH/3, height: 800))
        imgView.image = image
        self.view.addSubview(imgView)
        
        if let pngImageStr = image?.pngData()?.base64EncodedString() {
            if let pngImageData = Data(base64Encoded: pngImageStr, options: .ignoreUnknownCharacters) {
                if let pngImage = UIImage(data: pngImageData) {
                    let pngImgView = UIImageView(frame: CGRect(x: UIScreen.WIDTH/3, y: 80, width: UIScreen.WIDTH/3, height: 800))
                    pngImgView.image = pngImage
                    self.view.addSubview(pngImgView)
                }
            }
        }
        
        // 当图片比较大时， jpegData 方法转化成的 data 即使是 1.0，仍然会压缩图片
        if let jpegImageStr = image?.jpegData(compressionQuality: 1.0)?.base64EncodedString() {
            if let jpegImageData = Data(base64Encoded: jpegImageStr, options: .ignoreUnknownCharacters) {
                if let jpegImage = UIImage(data: jpegImageData) {
                    let jpegImgView = UIImageView(frame: CGRect(x: UIScreen.WIDTH*2/3, y:80, width: UIScreen.WIDTH/3, height: 800))
                    jpegImgView.image = jpegImage
                    self.view.addSubview(jpegImgView)
                }
            }
        }
        
        
    }

}
