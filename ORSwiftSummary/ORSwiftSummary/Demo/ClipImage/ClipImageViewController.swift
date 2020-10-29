//
//  ClipImageViewController.swift
//  UAgent
//
//  Created by orilme on 2020/01/09.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import UIKit
import QuartzCore
import Accelerate

protocol ClipImageViewControllerDelegate : NSObjectProtocol {
    func clipImageDidCancel()
    func clipImageDidFinished(image:UIImage)
}

class ClipImageViewController: UIViewController {
    
    weak var delegate : ClipImageViewControllerDelegate?
    // 裁剪的目标图片
    private var targetImage : UIImage = UIImage()
    // 裁剪的区域
    private var cropSize : CGSize = CGSize(width: UIScreen.WIDTH*0.75, height: UIScreen.WIDTH*0.5)
    // 裁切框的frame
    private var cropFrame = CGRect()
    // 待裁切的图片和裁切框的宽高关系， 用于做裁切处理。
    private var relationType = 0
    
    // MARK: - Setter & Getter
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.scrollsToTop = false
        view.maximumZoomScale = 10
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = UIView.ContentMode.scaleAspectFill
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black
        view.alpha = 0.5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }
    
    func setupUI() {
        let cancelBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        let leftItem = UIBarButtonItem.init(customView: cancelBtn)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let sureBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        sureBtn.setTitle("选取", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.addTarget(self, action: #selector(sureButtonClicked), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: sureBtn)
        
        let sureBtn2 = UIButton.init(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        sureBtn2.setTitle("旋转", for: .normal)
        sureBtn2.setTitleColor(.black, for: .normal)
        sureBtn2.addTarget(self, action: #selector(rotatingButtonClicked), for: .touchUpInside)
        let rightItem2 = UIBarButtonItem.init(customView: sureBtn2)
        
        self.navigationItem.setRightBarButtonItems([rightItem, rightItem2], animated: true)
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
        self.view.addSubview(backgroundView)
        
        self.backgroundView.frame = view.frame
        self.scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
    }
    
    // 设置初始化UI的数据，记录待裁切的图片，要裁切的尺寸
    func settingUIDataWithImage(_ image: UIImage, size:CGSize = CGSize(width: UIScreen.WIDTH*0.75, height: UIScreen.WIDTH*0.5)) {
        targetImage = image
        cropSize = size
        
        // 判断裁切框和图片的关系，用于做
        relationType = targetImage.judgeRelationTypeWithCropSize(cropSize)

        // 填充图片数据
        fillData()

        // 根据图片尺寸和裁切框的尺寸设置scrollView的最小缩放比例
        setMinZoomScale()
        
        // 矩形裁切框
        transparentCutSquareArea()
        
        scrollViewDidZoom(scrollView)
    }
    
    func fillData() {
        // 1.添加图片
        imageView.image = targetImage
        
        // 2.设置裁剪区域
        let x = (UIScreen.WIDTH - cropSize.width) / 2
        let y = (UIScreen.HEIGHT - cropSize.height) / 2
        cropFrame = CGRect(x: x, y: y, width: cropSize.width, height: cropSize.height)
        
        // 3.计算imgeView的frame
        let imageW = targetImage.size.width
        let imageH = targetImage.size.height
        let cropW = cropSize.width
        let cropH = cropSize.height
        var imageViewW, imageViewH, imageViewX, imageViewY : CGFloat
        switch relationType {
            case 0,1:  // 裁切框宽高比 > 0
                imageViewW = cropW
                imageViewH = imageH * imageViewW / imageW
                imageViewX = (UIScreen.WIDTH - imageViewW) / 2
                imageViewY = (UIScreen.HEIGHT - imageViewH)/2
            case 2,3:  // 裁切框宽高比 = 0
                imageViewW = cropW
                imageViewH = imageH * imageViewW / imageW
                imageViewX = (UIScreen.WIDTH - imageViewW) / 2
                imageViewY = (UIScreen.HEIGHT - imageViewH)/2
            default:
                imageViewH = cropH
                imageViewW = imageW * imageViewH / imageH
                imageViewX = (UIScreen.WIDTH - imageViewW) / 2
                imageViewY = (UIScreen.HEIGHT - imageViewH)/2
        }
        
        imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
    }
    
    //设置矩形裁剪区域
    func transparentCutSquareArea() {
        let alphaRect = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        let alphaPath = UIBezierPath.init(rect: alphaRect)
        let squarePath = UIBezierPath.init(rect: cropFrame)
        alphaPath.append(squarePath)
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = alphaPath.cgPath
        shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
        backgroundView.layer.mask = shapeLayer
        
        //裁剪框
        let cropRect_x = cropFrame.origin.x - 1
        let cropRect_y = cropFrame.origin.y - 1
        let cropRect_w = cropFrame.size.width + 2
        let cropRect_h = cropFrame.size.height + 2
        let cropRect = CGRect(x: cropRect_x, y: cropRect_y, width: cropRect_w, height: cropRect_h)
        let cropPath = UIBezierPath.init(rect: cropRect)
        
        
        let cropLayer = CAShapeLayer.init()
        cropLayer.path = cropPath.cgPath
        cropLayer.fillColor = UIColor.white.cgColor
        cropLayer.strokeColor = UIColor.white.cgColor
        backgroundView.layer.addSublayer(cropLayer)
    }
    
    // 设置最小缩放比例
    func setMinZoomScale() {
        // 设置最小的缩放比例。 自动填满裁剪区域
        var scale : CGFloat = 0
        
        let imageViewW = imageView.frame.size.width
        let imageViewH = imageView.frame.size.height

        let cropW = cropSize.width
        let cropH = cropSize.height
        
        
        switch relationType {
        case 0:  // 裁切框宽高比 > 1,并且裁切框宽高比 >= 图片宽高比
            scale = imageViewW  /  cropW
        case 1:  // 裁切框宽高比 > 1,并且裁切框宽高比 < 图片宽高比
            scale = cropH / imageViewH
        case 2:   // 裁切框宽高比 = 1, 并且裁切框宽高比 >= 图片宽高比
            scale = cropW / imageViewW
        case 3:  // 裁切框宽高比 = 1, 并且裁切框宽高比 < 图片宽高比
            scale = cropH / imageViewH
        case 4:  // 裁切框宽高比 < 1,并且裁切框宽高比 >= 图片宽高比
            scale = cropW / imageViewW
        default: // 裁切框宽高比 < 1,并且裁切框宽高比 < 图片框宽高比
            scale = cropW / imageViewW
        }
        
        //自动缩放填满裁剪区域
        self.scrollView.setZoomScale(scale, animated: false)
        //设置刚好填充满裁剪区域的缩放比例，为最小缩放比例
        self.scrollView.minimumZoomScale = scale
    }
    
    // 获取被裁剪的图片
    func getClippingImage() -> UIImage {
        /** 步骤
         * 1. 获取图片和imageView的缩放比例。
         * 2. 获取ImageView的缩放比例，即scrollView.zoomScale
         * 3. 获取ImageView的原始坐标
         * 4. 计算缩放后的坐标
         * 5. 计算裁剪区域在原始图片上的位置
         * 6. 裁剪图片，没有了release方法，CGImage会存在内存泄露么
         */
        //图片大小和当前imageView的缩放比例
        let scaleRatio = targetImage.size.width / imageView.frame.size.width
        //scrollView的缩放比例，即是ImageView的缩放比例
        let scrollScale = self.scrollView.zoomScale
        
        //裁剪框的 左上、右上和左下三个点在初始ImageView上的坐标位置（注意：转换后的坐标为原始ImageView的坐标计算的，而非缩放后的）
        var leftTopPoint = view.convert(cropFrame.origin, to: imageView)
        var rightTopPoint = view.convert(CGPoint.init(x: cropFrame.origin.x + cropSize.width, y: cropFrame.origin.y), to: imageView)
        var leftBottomPoint = view.convert(CGPoint.init(x: cropFrame.origin.x, y: cropFrame.origin.y + cropSize.height), to: imageView)
        
        //计算三个点在缩放后imageView上的坐标
        leftTopPoint = CGPoint.init(x: leftTopPoint.x * scrollScale, y: leftTopPoint.y*scrollScale)
        rightTopPoint = CGPoint.init(x: rightTopPoint.x * scrollScale, y: rightTopPoint.y*scrollScale)
        leftBottomPoint = CGPoint.init(x: leftBottomPoint.x * scrollScale, y: leftBottomPoint.y*scrollScale)
        
        
        //计算裁剪区域在原始图片上的位置
        let width = (rightTopPoint.x - leftTopPoint.x ) * scaleRatio
        let height = (leftBottomPoint.y - leftTopPoint.y) * scaleRatio
        let myImageRect = CGRect(x: leftTopPoint.x * scaleRatio, y: leftTopPoint.y*scaleRatio, width: width, height: height)
        
        //裁剪图片
        let imageRef : CGImage = targetImage.cgImage!
        let subImageRef = imageRef.cropping(to: myImageRect)
        UIGraphicsBeginImageContextWithOptions(myImageRect.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(subImageRef!, in: CGRect(x: 0, y: 0, width: myImageRect.size.width, height: myImageRect.size.height))
        
        let subImage = UIImage.init(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        
        return subImage
    }
    
    
    // MARK: Action
    @objc func cancelButtonClicked() {
        if delegate != nil {
            delegate?.clipImageDidCancel()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sureButtonClicked() {
        let image = getClippingImage()
        if delegate != nil {
            delegate?.clipImageDidFinished(image: image)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // 图片旋转
    @objc func rotatingButtonClicked() {
        // 清空之前设置的scale。否则会错乱
        scrollView.minimumZoomScale = 1.0
        scrollView.setZoomScale(1.0, animated: true)
        
        targetImage = targetImage.rotationImage(orientation: .left)
        imageView.image = targetImage
        settingUIDataWithImage(targetImage, size: cropSize)
    }
    
}


extension ClipImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        //图片比例改变以后，让改变后的ImageView保持在ScrollView的中央
        let size_W = scrollView.bounds.size.width
        let size_H = scrollView.bounds.size.height

        let contentSize_W = scrollView.contentSize.width
        let contentSize_H = scrollView.contentSize.height
        
        
        let offsetX = (size_W > contentSize_W) ? (size_W - contentSize_W) * 0.5 : 0.0
        let offsetY = (size_H > contentSize_H) ? (size_H - contentSize_H) * 0.5 : 0.0
        imageView.center = CGPoint.init(x: contentSize_W * 0.5 + offsetX, y: contentSize_H * 0.5 + offsetY)
        
        
        //设置scrollView的contentSize，最小为self.view.frame.size
        let scrollW = contentSize_W >= UIScreen.WIDTH ? contentSize_W : UIScreen.WIDTH
        let scrollH = contentSize_H >= UIScreen.HEIGHT ? contentSize_H : UIScreen.HEIGHT
        scrollView.contentSize = CGSize.init(width: scrollW, height: scrollH)
        
        
        //设置scrollView的contentInset
        let imageWidth = imageView.frame.size.width;
        let imageHeight = imageView.frame.size.height;
        let cropWidth = cropSize.width;
        let cropHeight = cropSize.height;
        
        var leftRightInset : CGFloat = 0;
        var topBottomInset : CGFloat = 0;
        
        //imageview的大小和裁剪框大小的三种情况，保证imageview最多能滑动到裁剪框的边缘
        if (imageWidth <= cropWidth) {
            leftRightInset = 0;
        } else if (imageWidth >= cropWidth && imageWidth <= UIScreen.WIDTH) {
            leftRightInset = (imageWidth - cropWidth) * 0.5
        }else{
            leftRightInset = (UIScreen.WIDTH - cropSize.width) * 0.5
        }
        
        if (imageHeight <= cropHeight) {
            topBottomInset = 0
        } else if (imageHeight >= cropHeight && imageHeight <= UIScreen.HEIGHT) {
            topBottomInset = (imageHeight - cropHeight) * 0.5
        } else {
            topBottomInset = (UIScreen.HEIGHT - cropSize.height) * 0.5
        }
        
        scrollView.contentInset = UIEdgeInsets(top: topBottomInset, left: leftRightInset, bottom: topBottomInset, right: leftRightInset)
    }
}
