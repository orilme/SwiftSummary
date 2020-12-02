//
//  CustomAnimatePush.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/18.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class CustomAnimatePush: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    var transitionContext:UIViewControllerContextTransitioning?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        self.transitionContext = transitionContext
        
        // 获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewController(forKey: .from) as! PushAnimationVC
        let toVC = transitionContext.viewController(forKey: .to) as! PushedVC

        //获取容器视图
        let contView = transitionContext.containerView

        let button = fromVC.button

        let maskStartBP =  UIBezierPath.init(rect: button.frame)
        // 都添加到container中。注意顺序
        contView.addSubview(fromVC.view)
        contView.addSubview(toVC.view)


        let maskFinalBP = UIBezierPath.init(rect: CGRect(x: 0, y: 100, width: UIScreen.WIDTH, height: 200))

        // 创建一个 CAShapeLayer 来负责展示圆形遮盖
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskFinalBP.cgPath //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
        toVC.view.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartBP.cgPath
        maskLayerAnimation.toValue = maskFinalBP.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //告诉 iOS 这个 transition 完成
        self.transitionContext?.completeTransition(true)
        //清除 fromVC 的 mask
        if let frmoView = self.transitionContext?.view(forKey: .from) {
            frmoView.layer.mask = nil
        }
        
        if let toView = self.transitionContext?.view(forKey: .to) {
            toView.layer.mask = nil
        }
    }

}
