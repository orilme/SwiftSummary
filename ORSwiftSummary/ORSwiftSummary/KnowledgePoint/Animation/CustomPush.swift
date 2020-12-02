//
//  CustomPush.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/23.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class CustomPush: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    var transitionContext:UIViewControllerContextTransitioning?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewController(forKey: .from) as! PushAnimationVC
        let toVC = transitionContext.viewController(forKey: .to) as! PushedVC
        

        //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
        let contView = transitionContext.containerView

        let button = fromVC.button

        //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
        let imageViewCopy = button.snapshotView(afterScreenUpdates: false)
        imageViewCopy?.frame = button.convert(imageViewCopy?.bounds ?? CGRect.zero, to: contView)
        

        //设置动画前的各个控件的状态
        //button.isHidden = true
        toVC.imageView.isHidden = true

        
        //tempView 添加到containerView中，要保证在最上层，所以后添加
        contView.addSubview(toVC.view)
        if let cView =  imageViewCopy {
            contView.addSubview(cView)
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            imageViewCopy?.frame = toVC.imageView.convert(toVC.imageView.bounds, to: contView)
        }) { (finished) in
            toVC.imageView.isHidden = false
            imageViewCopy?.removeFromSuperview()
            //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
            transitionContext.completeTransition(true)
        }
        
    }
    
}
