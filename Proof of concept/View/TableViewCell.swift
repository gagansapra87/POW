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
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        self.initViews()
    }
    
    func initViews() {
        
        self.contentView.addSubview(self.imgView_item)
        self.contentView.addSubview(self.lbl_title)
        self.contentView.addSubview(self.lbl_subTitle)
        
        self.imgView_item.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(10)
            make.bottomMargin.equalTo(self.lbl_title).offset(-30)
        }
        
        self.lbl_title.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView_item)
            make.right.equalTo(self.imgView_item)
            make.top.equalTo(self.imgView_item.snp.bottomMargin)
            make.bottomMargin.equalTo(self.lbl_subTitle.snp.topMargin)
        }
        
        self.lbl_subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.lbl_title.snp.bottomMargin)
            make.left.equalTo(self.imgView_item)
            make.right.equalTo(self.imgView_item)
            make.bottomMargin.equalTo(self.contentView.snp.bottomMargin).offset(-15)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
