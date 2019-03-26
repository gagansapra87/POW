//
//  TableViewCell.swift
//  Proof of concept
//
//  Created by MAC on 17/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {

    var lbl_title = UILabel()
    var lbl_subTitle = UILabel()
    var imgView_item = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        
        /*
         Add image view and label in cell's content view and setup constraints
         */
        
        self.contentView.addSubview(self.imgView_item)
        self.contentView.addSubview(self.lbl_title)
        self.contentView.addSubview(self.lbl_subTitle)
        
        self.imgView_item.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-20)
        }
        
        self.lbl_title.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView_item)
            make.right.equalTo(self.imgView_item)
            make.top.equalTo(self.imgView_item.snp.bottomMargin).offset(20)
        }
        
        self.lbl_subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.lbl_title.snp.bottomMargin).offset(20)
            make.left.equalTo(self.imgView_item)
            make.right.equalTo(self.imgView_item)
            make.bottomMargin.equalTo(self.contentView.snp.bottomMargin).offset(-15)
        }
    }
}
