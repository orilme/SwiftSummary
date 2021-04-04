//
//  MessageBox.swift
//  UGLibrary_Example
//
//  Created by yj on 2018/1/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

private var ResultViewKey: Void?

public class ResultView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var button: UIButton!
    
    var handle:(()->Void)?
    
    var canTap = true
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.button.layer.cornerRadius = 4
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    @discardableResult
    public class func show(onView view: UIView,
                           image:UIImage? = nil,
                           title:String? = nil,
                           detail:String? = nil,
                           action:String? = nil,
                           handle:@escaping ()-> Void) -> ResultView {
        
        let resultView:ResultView
        if let cacheView = objc_getAssociatedObject(view, &ResultViewKey) as? ResultView{
            resultView = cacheView
            if resultView.superview == nil{
                view.addSubview(resultView)
            }
        }else{
            let nib = UINib(nibName: "ResultView", bundle: Bundle(for: ResultView.self))
            let nibView = nib.instantiate(withOwner: nil, options: nil).first as! ResultView
            
            objc_setAssociatedObject(view, &ResultViewKey, nibView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            resultView = nibView
            view.addSubview(resultView)
            resultView.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
            resultView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            
        }
        
        resultView.titleConstraint.constant = (title == nil) ? 0 : 15
        resultView.detailConstraint.constant = (detail == nil) ? 0 : 15
        if let image = image {
            resultView.imageView.image = image
        }
        resultView.titleLabel.text = title
        resultView.detailLabel.text = detail
        resultView.button.setTitle(action, for: .normal)
        resultView.button.isHidden = action == nil
        resultView.handle = handle
        
        return resultView
    }
    
    public class func hidden(from view: UIView){
        for subView in view.subviews {
            if let resultView = subView as? ResultView{
                resultView.hidden()
            }
        }
    }
    
    public func hidden(){
        self.removeFromSuperview()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
        self.handle?()
    }
    
    @objc func tapAction(){
        if self.canTap {
            self.handle?()
        }
    }
    
}

