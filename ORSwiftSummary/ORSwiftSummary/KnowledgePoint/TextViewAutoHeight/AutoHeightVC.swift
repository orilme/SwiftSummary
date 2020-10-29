//
//  AutoHeightVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/27.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

public extension NSObject {
    public var className: String {
        return String(describing: type(of: self))
    }
    
    public class var className: String {
        return String(describing: self)
    }
}

class AutoHeightVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //每次内容变化时，调用tableView的刷新方法
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
        mainTableView.beginUpdates()
        mainTableView.endUpdates()
    }

    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: UIScreen.NAVHEIGHT, width: UIScreen.WIDTH, height: UIScreen.HEIGHT - UIScreen.IPHONXSafeBottom - UIScreen.NAVHEIGHT), style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .green
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 115
        tableView.register(UINib.init(nibName: FBTopSelectCell.className, bundle: nil), forCellReuseIdentifier: FBTopSelectCell.className)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FBTopSelectCell.className) as! FBTopSelectCell
        cell.textView.delegate = self
        cell.backgroundColor = UIColor.red
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}
