//
//  KnowledgePointVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/24.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

class KnowledgePointVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    ["menuName": "Block 循环引用", "className": "BlockVC"],
    ["menuName": "自适应高度textView", "className": "AutoHeightVC"],
    ["menuName": "基本语法", "className": "BasicGrammarVC"],
    ["menuName": "GCD 信号量使用 弹窗依次弹出", "className": "GCDSemaphoreVC"],
    ["menuName": "RxSwift", "className": "RxSwiftVC"],
    ["menuName": "Image 转 Data 清晰度对比", "className": "ImageChangeDataVC"],
    ["menuName": "自定义转场动画", "className": "PushAnimationVC"],
    ["menuName": "动画", "className": "AnimationVC"],
    ["menuName": "钥匙串存储密码", "className": "KeyChainVC"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "基础知识点~~";
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
