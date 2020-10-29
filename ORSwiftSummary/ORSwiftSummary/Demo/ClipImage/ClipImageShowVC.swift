//
//  ClipImageShowVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/26.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

import TZImagePickerController

class ClipImageShowVC: UIViewController, TZImagePickerControllerDelegate {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x: UIScreen.WIDTH*0.1225, y: 220, width: UIScreen.WIDTH*0.75, height: UIScreen.WIDTH*0.5))
        imageView.backgroundColor = UIColor.green
        return imageView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(imageView)

        let selectBtn = UIButton.init(frame: CGRect(x: 60, y: 90, width: 100, height: 50))
        selectBtn.setTitle("选择照片", for: .normal)
        selectBtn.backgroundColor = UIColor.purple
        selectBtn.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)
        self.view.addSubview(selectBtn)

    }

    @objc func openPhotoAlbum() {
        let vc = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        vc?.alwaysEnableDoneBtn = true
        vc?.showPhotoCannotSelectLayer = true
        vc?.showSelectedIndex = true
        vc?.allowPickingImage = true
        vc?.allowPickingGif = false
        vc?.allowTakePicture = false
        vc?.allowPickingVideo = false
        vc?.showSelectBtn = true
        self.present(vc!, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if photos.count > 0 {
            let vc = ClipImageViewController()
            vc.delegate =  self
            vc.settingUIDataWithImage(photos[0])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension ClipImageShowVC : ClipImageViewControllerDelegate {

    func clipImageDidCancel() {
        print("点击了取消按钮")
    }

    func clipImageDidFinished(image: UIImage) {
        print("获得了图片----")

        imageView.image = image

    }

}
