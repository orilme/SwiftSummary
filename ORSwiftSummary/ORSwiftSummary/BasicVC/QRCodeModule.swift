//
//  QRCodeModule.swift
//  UAgent
//
//  Created by sunny on 2019/7/17.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import Foundation


class QRCodeModule {
    
    weak var scannerController: ScannerViewController?
    
    weak var showController: UIViewController?
    
    func show(controller: UIViewController) {
        
        self.showController = controller
        let scannerController  =  ScannerViewController()
        self.scannerController = scannerController
                
        scannerController.setupScanner(UIColor.red,
                                       .default,
                                       "将二维码放入框内，即可自动扫描", {(code) in
                                        print("111------------------")
        })
        scannerController.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(scannerController, animated: true)
    }
    
    
}
