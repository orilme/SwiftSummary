//
//  GyroscopeImageView.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/10/16.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit
import CoreMotion

class GyroscopeImageView: UIView {
    
    public lazy var moveImgView:UIImageView = {
        let moveImgView = UIImageView()
        return moveImgView
    }()
    
    public lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.maximumZoomScale = 5.0
        scroll.minimumZoomScale = 1.0
        scroll.panGestureRecognizer.isEnabled = false
        scroll.pinchGestureRecognizer?.isEnabled = false
        scroll.panGestureRecognizer.cancelsTouchesInView = false
        
        return scroll
    }()
    
    /// 图片最大偏移量
    private var mMaxOffsetX:CGFloat = 0.00
    private var mMaxOffsetY:CGFloat = 0.00
    
    /// 陀螺仪在X、Y轴旋转的最大弧度
    /// The value must between (0, π  / 8).
    private var mMaxRotateRadian:CGFloat = CGFloat(Double.pi / 8)

    /// 相对于初始位置的旋转弧度
    private var mRotateRadianX:CGFloat = 0.00
    private var mRotateRadianY:CGFloat = 0.00
    
    /// 相对初始位置的偏移距离
    private var progressX:CGFloat = 0.00
    private var progressY:CGFloat = 0.00
    
    /// 偏移的距离
    private var currentOffsetX:CGFloat = 0.00
    private var currentOffsetY:CGFloat = 0.00
    
    /// 是否初始化过
    private var isReload:Bool = false
    /// 第一次加载的view的size
    private var startSize:CGSize = CGSize.zero
    /// 第一次加载的时候img的size
    private var startImgSize:CGSize = CGSize.zero
    
    /// 是否需要更新frame
    private var isGyroscopeUpdate: Bool = true
    /// view所在的控制器
    private weak var parentVC: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        gyroscopeImageViewLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        gyroscopeImageViewLoad()
    }
    
    func gyroscopeImageViewLoad() {
        clipsToBounds = true
        scrollView.addSubview(moveImgView)
        addSubview(scrollView)
        GyroMannager.shared.monitorDeviceMotion(index: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(motionManagerUpdates(_:)), name: NSNotification.Name(rawValue: "kCMMotionManagerUpdatesNotification"), object: nil)
    }
    
    @objc func motionManagerUpdates(_ notification: NSNotification) {
        if let vc = self.parentVC {
            /// 判断不在VR所在的界面时不执行后面的代码，不移动VR
            isGyroscopeUpdate = vc.isViewLoaded && (vc.view.window != nil)
            print("陀螺仪---Updates---2", isGyroscopeUpdate, (vc.view.window != nil))
        }
        /// 隐藏不刷新，当前控制器不在最前面不刷新
        guard !isHidden,
            isGyroscopeUpdate,
            let gyroData = notification.userInfo?["gyroData"] as? CMDeviceMotion else {
            return
        }
        print("陀螺仪---Updates---1")
        let x = CGFloat(gyroData.rotationRate.x)
        let y = CGFloat(gyroData.rotationRate.y)
        self.imagePanTransform(x: x, y: y)
    }
    
    /* 设置移动的imageView 的 frame
     * 注意: 调用此方法时必须等GyroscopeImageView加载完成调用，或者传入width，height 即GyroscopeImageView的宽高，否则可能会引起显示偏移
     */
    func setMoveImgViewFrame(width: CGFloat?, height: CGFloat?) {
        if isReload == true {
            updateMoveImgViewFrame(height: self.frame.size.height)
            return
        }
        isReload = true
        var containerWidth = self.frame.size.width
        var containerHeight = self.frame.size.height
        if let cwidth = width {
            containerWidth = cwidth
        }
        if let cheight = height {
            containerHeight = cheight
        }
        moveImgView.sizeToFit()
        let imgWidth = moveImgView.frame.size.width
        let imgHeight = moveImgView.frame.size.height
        
        var newHeight = imgHeight
        var newWidth = imgWidth
        if imgWidth/imgHeight > containerWidth/containerHeight {
            newHeight = containerHeight * 1.25
            newWidth = newHeight * (imgWidth / imgHeight)
        } else {
            newWidth = containerWidth * 1.25
            newHeight = newWidth * (imgHeight / imgWidth)
        }
        mMaxOffsetX = (newWidth - containerWidth) * 0.5
        mMaxOffsetY = (newHeight - containerHeight) * 0.5
        startSize = CGSize(width: containerWidth, height: containerHeight)
        startImgSize = CGSize(width: newWidth, height: newHeight)
        moveImgView.frame = CGRect(x: -self.mMaxOffsetX, y: -self.mMaxOffsetY, width: newWidth, height: newHeight)
        scrollView.frame = CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight)
        self.parentVC = self.firstViewController()
    }
    
    /// 下拉重新加载过程跟新view frame
    func updateMoveImgViewFrame(height: CGFloat) {
        let ratio = height/startSize.height
        scrollView.setZoomScale(ratio, animated: false)
        //scrollView.mj_size = CGSize(width: startImgSize.width, height: startImgSize.height * ratio)
    }

    /// 更新 imagView 的 frame
    func imagePanTransform(x: CGFloat, y: CGFloat) {
        #if DEBUG
        //print("监听到陀螺仪，正在刷新frame---", x, y)
        #endif
        if abs(x) < 0.01, abs(y) < 0.01 {
            /// 晃动幅度过小不更新frame，要不然太频繁
            //print("晃动幅度过小不更新frame，要不然太频繁")
            return
        }
        let timestamp = GyroMannager.shared.timestamp
        mRotateRadianY += y * timestamp
        mRotateRadianX += x * timestamp

        if (mRotateRadianY > mMaxRotateRadian) {
            mRotateRadianY = mMaxRotateRadian
        }
        else if (mRotateRadianY < -mMaxRotateRadian) {
            mRotateRadianY = -mMaxRotateRadian
        }
        if (mRotateRadianX > mMaxRotateRadian) {
            mRotateRadianX = mMaxRotateRadian
        }
        else if (mRotateRadianX < -mMaxRotateRadian) {
            mRotateRadianX = -mMaxRotateRadian
        }
        
        progressX = mRotateRadianY/mMaxRotateRadian
        progressY = mRotateRadianX/mMaxRotateRadian
        
        currentOffsetX = mMaxOffsetX * progressX
        currentOffsetY = mMaxOffsetY * progressY
        
        var frame = moveImgView.frame
        frame.origin.x = -mMaxOffsetX + currentOffsetX
        frame.origin.y = -mMaxOffsetY + currentOffsetY
        self.moveImgView.frame = frame
    }
    
    deinit {
        print("陀螺仪---view释放")
        GyroMannager.shared.monitorDeviceMotion(index: -1)
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension GyroscopeImageView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.panGestureRecognizer.isEnabled  = false
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.panGestureRecognizer.isEnabled  = false
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return moveImgView
    }
    
}

extension UIView {
    func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
