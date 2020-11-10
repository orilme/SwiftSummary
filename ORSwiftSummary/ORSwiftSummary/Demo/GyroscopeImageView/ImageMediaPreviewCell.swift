//
//  ImageMediaPreviewCell.swift
//  UAgent
//
//  Created by TY on 2019/5/11.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import UIKit

class ImageMediaPreviewCell: UICollectionViewCell {
    
    @IBOutlet weak var gyroImgView: GyroscopeImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        gyroImgView.moveImgView.image = UIImage.init(named: "img_back")
    }
    
    public func setCell() {
        gyroImgView.setMoveImgViewFrame(width: self.frame.size.width, height: self.frame.size.height)
        print("setCell----", gyroImgView.frame, self.frame)
    }

}
