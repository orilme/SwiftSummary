//
//  TakeIDcardPhotoTwoVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/27.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class TakeIDcardPhotoTwoVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }


    @IBAction func frontClick(_ sender: Any) {
        let vc = DXIDCardCameraController.init(type: DXIDCardType.front)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func reverseClick(_ sender: Any) {
        let vc = DXIDCardCameraController.init(type: DXIDCardType.reverse)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension TakeIDcardPhotoTwoVC : DXIDCardCameraControllerProtocol {
    func cameraDidFinishShootWithCameraImage(image: UIImage) {
        self.imageView.image = image
    }
}
