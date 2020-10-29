//
//  PopFilterView.swift
//  UAgent
//
//  Created by orilme on 2020/7/18.
//  Copyright © 2020 com.yjyz.www. All rights reserved.
//

import UIKit

class PopFilterView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var list = [String]()
    
    var didSelect : ((_ indexPath: IndexPath)->Void)?
    
    init(frame: CGRect, style: UITableView.Style, list:[String]) {
        super.init(frame: frame, style: style)
        self.separatorInset = UIEdgeInsets.zero
        self.isScrollEnabled = false
        self.list = list
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = self.list[indexPath.row]
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelect?(indexPath)
    }

}
