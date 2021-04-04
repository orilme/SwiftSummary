//
//  HUD.swift
//  Alamofire
//
//  Created by yj on 2018/1/16.
//

import MBProgressHUD

public class HUD{
    
    private var hud:MBProgressHUD!
    
    var label:UILabel {
        return self.hud.label
    }
    
    var detailsLabel:UILabel {
        self.hud.detailsLabel.numberOfLines = 0
        return self.hud.detailsLabel
    }
    
    var progress:Float = 0 {
        didSet{
            self.hud.progress = progress
        }
    }
    
    
    public func hide(animated: Bool){
        hud.hide(animated: animated)
    }
    
    @discardableResult
    public static func load(onView view: UIView,
                            title:String? = nil,
                            details:String? = nil) -> HUD {
        let hud = HUD()
        let progresshud = MBProgressHUD.showAdded(to: view, animated: true)
        progresshud.isUserInteractionEnabled = false
        progresshud.label.text = title
        progresshud.label.font = UIFont.systemFont(ofSize: 15)
        progresshud.detailsLabel.text = details
        hud.hud = progresshud
        
        if let _ = view as? UIScrollView {
            // 暂时用-88适配
           progresshud.offset = CGPoint(x: 0, y: -88)
        }
        
        return hud
    }
    
    @discardableResult
    public static func showText(onView view: UIView,
                            title:String,
                            details:String? = nil) -> HUD {
        
        let hud = HUD()
        let progresshud = MBProgressHUD.showAdded(to: view, animated: true)
        progresshud.label.text = title
        progresshud.mode = .text
        progresshud.label.numberOfLines = 0
        progresshud.label.font = UIFont.systemFont(ofSize: 15)
        progresshud.detailsLabel.text = details
        progresshud.detailsLabel.numberOfLines = 0
        progresshud.hide(animated: true, afterDelay: 1.5)
        hud.hud = progresshud
        progresshud.isUserInteractionEnabled = false
        
        return hud
    }
    
    @discardableResult
    public static func showText(onView view: UIView,
                                title:String,
                                details:String? = nil,
                                completion: (() -> Void)? = nil) -> HUD {
        
        let hud = HUD()
        let progresshud = MBProgressHUD.showAdded(to: view, animated: true)
        progresshud.label.text = title
        progresshud.mode = .text
        progresshud.label.numberOfLines = 0
        progresshud.label.font = UIFont.systemFont(ofSize: 15)
        progresshud.detailsLabel.text = details
        progresshud.detailsLabel.numberOfLines = 0
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            progresshud.hide(animated: true)
            completion?()
        }
        
        hud.hud = progresshud
        progresshud.isUserInteractionEnabled = false
        
        return hud
    }
    

    @discardableResult
    public static func annularProgress(onView view: UIView,
                                      title:String,
                                      details:String? = nil) -> HUD{
        
        let hud = HUD()
        let progresshud = MBProgressHUD.showAdded(to: view, animated: true)
            progresshud.label.text = title
            progresshud.label.font = UIFont.systemFont(ofSize: 15)
            progresshud.detailsLabel.text = details
            progresshud.mode = .annularDeterminate
            hud.hud = progresshud
        
        return hud
    }
    
    @discardableResult
    public static func barProgress(onView view: UIView,
                                       title:String,
                                       details:String? = nil) -> HUD{
        
        let hud = HUD()
        let progresshud = MBProgressHUD.showAdded(to: view, animated: true)
            progresshud.label.text = title
            progresshud.detailsLabel.text = details
            progresshud.mode = .determinateHorizontalBar
            hud.hud = progresshud
        
        return hud
    }
    
    public static func hide(from view: UIView, animated: Bool) {
        MBProgressHUD.hide(for: view, animated: animated)
    }
    
    public func show(animated: Bool) {
        self.hud.show(animated: animated)
    }
}
