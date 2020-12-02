//
//  PushAnimationVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/18.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class PushAnimationVC: UIViewController, UINavigationControllerDelegate {
    
    var button = UIButton()

    var sureBtn2 = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .purple
        setBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if(operation == .push) {
            return CustomPush()
        }else {
            return nil
        }
    }
    
    func setBtn() {
        let sureBtn = UIButton.init(frame: CGRect(x: 20, y: 200, width: 100, height: 50))
        sureBtn.setImage(UIImage(named: "img_back"), for: .normal)
        sureBtn.addTarget(self, action: #selector(pushVC(btn:)), for: .touchUpInside)
        self.view.addSubview(sureBtn)
        
        sureBtn2 = UIButton.init(frame: CGRect(x: 20, y: 400, width: 100, height: 50))
        sureBtn2.setImage(UIImage(named: "img_back"), for: .normal)
        sureBtn2.alpha = 0.2
        sureBtn2.addTarget(self, action: #selector(pushVC2(btn:)), for: .touchUpInside)
        self.view.addSubview(sureBtn2)
        
        let sureBtn3 = UIButton.init(frame: CGRect(x: 20, y: 600, width: 100, height: 50))
        sureBtn3.setImage(UIImage(named: "img_back"), for: .normal)
        sureBtn3.addTarget(self, action: #selector(pushVC(btn:)), for: .touchUpInside)
        self.view.addSubview(sureBtn3)
    }
    
    @objc func pushVC(btn : UIButton) {
        button = btn
        let vc = PushedVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushVC2(btn : UIButton) {
        UIView.transition(with: btn, duration: 2, options: .transitionCrossDissolve, animations: {
            self.sureBtn2.alpha = 1
        }) { (_) in
            
        }
    }
    
    

}
