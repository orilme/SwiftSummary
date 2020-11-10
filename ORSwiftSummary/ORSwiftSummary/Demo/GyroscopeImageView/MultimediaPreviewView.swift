//
//  MultimediaPreviewView.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/6.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit
import SnapKit

class MultimediaPreviewView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public var collectionView: UICollectionView!
    public var currentIndex : Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews---")
        collectionView.frame = self.bounds
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib.init(nibName: ImageMediaPreviewCell.className, bundle: nil), forCellWithReuseIdentifier: ImageMediaPreviewCell.className)
        self.addSubview(collectionView)
        collectionView.backgroundColor = .green
        collectionView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize.init(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageMediaPreviewCell.className, for: indexPath) as! ImageMediaPreviewCell
        cell.setCell()
        cell.backgroundColor = .yellow
        return cell
    }
    
}
