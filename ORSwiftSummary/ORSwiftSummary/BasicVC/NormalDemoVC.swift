//
//  NormalDemoVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/24.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class NormalDemoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: UIScreen.NAVHEIGHT, width: UIScreen.WIDTH, height: UIScreen.HEIGHT - UIScreen.IPHONXSafeBottom - UIScreen.NAVHEIGHT), style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    var meunArr = [
    ["menuName": "裁切图片", "className": "ClipImageShowVC"],
    ["menuName": "相机拍身份证", "className": "TakeIDcardPhotoVC"],
    ["menuName": "相机拍身份证2", "className": "TakeIDcardPhotoTwoVC"],
    ["menuName": "气泡菜单", "className": "PopoverViewVC"],
    ["menuName": "陀螺仪使用-晃动手机移动图片", "className": "CoreMotionVC"],
    ["menuName": "陀螺仪使用-晃动手机移动图片-collectionView中", "className": "CMCollectionVC"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Demo";
        if #available(iOS 11.0, *) {
            self.mainTableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        setupUI()
    }
    
    func setupUI() {

    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meunArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className)!
        cell.textLabel?.text = meunArr[indexPath.row]["menuName"]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = meunArr[indexPath.row]
        let classStr:String = dict["className"] ?? ""
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]as!String
        let vcClass = NSClassFromString(namespace+"."+classStr)!as!UIViewController.Type
        let vc = vcClass.init()
        vc.title = dict["menuName"]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
