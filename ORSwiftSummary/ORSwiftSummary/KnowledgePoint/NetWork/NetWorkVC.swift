//
//  NetWorkVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/12.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit
import BaseLibrary

class NetWorkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .blue
        request(TestNet.getInTheCompany).loading(onView: view).failure { (error) in
            
        }.responseObject { (model: InTheCompanyModel) in
            print("NetWorkVC---", model.branchId)
        }
        
    }

}

class InTheCompanyModel: Codable {
    var branchId : String?
}

enum TestNet {
    case getInTheCompany
}

extension TestNet: NetTargetType {
    var target: NetTarget {
        switch self {
            case .getInTheCompany:
                return NetTarget(path: "/erp.settings.api/employees/inTheCompany", method: .post)
        }
    }
}
