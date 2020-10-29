//
//  PopoverViewVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/27.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class PopoverViewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let sureBtn = UIButton.init(frame: CGRect(x: 20, y: 100, width: 100, height: 50))
        sureBtn.backgroundColor = UIColor.green
        sureBtn.setTitle("气泡", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.addTarget(self, action: #selector(showPopover(button:)), for: .touchUpInside)
        self.view.addSubview(sureBtn)
        
    }

    // MARK: Action
    @objc func showPopover(button: UIButton) {
        let options: [PopoverViewOption] = [.type(.down), .showBlackOverlay(false), .showShadowy(true), .arrowPositionRatio(0.3), .arrowSize(CGSize(width: 12, height: 13)), .color(.white)]
        let pop = PopoverView.init(options: options)
        let contentView = PopFilterView.init(frame: CGRect(x: 0, y: 0, width: 150, height: 175), style: .plain, list: ["访问时间倒叙", "访问时间正序", "访问次数倒叙", "访问次数正序"])
        contentView.didSelect = { [weak self] (indexPath) in
            pop.dismiss()
            button.isSelected = false
        }
        pop.contentView = contentView
        pop.show(pop.contentView, fromView: button)
    }
    
}
