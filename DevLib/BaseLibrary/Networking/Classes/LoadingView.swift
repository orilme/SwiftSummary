//
//  LoadingView.swift
//  Loading
//
//  Created by sunny on 2019/8/5.
//  Copyright © 2019 sunny. All rights reserved.
//

import UIKit
import Lottie

private var LoadingViewKey: Void?

public class LoadingView: UIView {

    let animationView = AnimationView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    func setUp(){
        
        
        let animation = Animation.named("loading", subdirectory: "Animations")
        animationView.animation = animation
        self.addSubview(animationView)
        
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
    }
    
    @discardableResult
    public class func load(onView view: UIView) -> LoadingView {
        
        let loadingView: LoadingView
        if let cacheView = objc_getAssociatedObject(view, &LoadingViewKey) as? LoadingView{
            loadingView = cacheView
            if loadingView.superview == nil{
                view.addSubview(loadingView)
            }
        }else{
            loadingView = LoadingView()
            objc_setAssociatedObject(view, &LoadingViewKey, loadingView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            view.addSubview(loadingView)
            loadingView.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
            loadingView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            
        }
        loadingView.animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop)
        return loadingView
    }
    
    public class func hidden(from view: UIView){
        for subView in view.subviews {
            if subView.isKind(of: LoadingView.self){
                subView.removeFromSuperview()
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
