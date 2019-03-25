//
//  ViewController.swift
//  Proof of concept
//
//  Created by MAC on 17/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    let textCellIndetifier = "TableViewCell"
    var tableView = UITableView()
    let viewModelClass = viewModel()
    var arr_data = [Data]()
    
    let imageCache = NSCache<NSString, UIImage>()
    let refresh = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.setupTableView()
        self.getListAPI()
    }
    
    //MARK: SetupTableView
    
    func setupTableView() {
        
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: textCellIndetifier)
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        refresh.addTarget(self, action: #selector(getListAPI), for: .valueChanged)
        refresh.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresh.attributedTitle = NSAttributedString.init(string: REFRESH)
        self.tableView.refreshControl = refresh
        
        DispatchQueue.main.async {
            self.tableView.frame = self.view.bounds
            self.view.addSubview(self.tableView)
            self.view.layoutIfNeeded()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: GetListAPI
    
    @objc private func getListAPI() {
        
        viewModelClass.getAllDataAPI(vc: self) { (data) in
            DispatchQueue.main.async {
                self.arr_data = data
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                self.refresh.endRefreshing()
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: textCellIndetifier, for: indexPath) as! TableViewCell
            let model = arr_data[indexPath.row]
            
            if model.imageHref.isEmpty == false {
               
                let urlString  = URL.init(string: model.imageHref)
                
                cell.imgView_item.sd_setIndicatorStyle(.white)
                cell.imgView_item.sd_setShowActivityIndicatorView(true)
                
                cell.imgView_item.sd_setImage(with: urlString) { (loadedImage, error, cacheType, url) in
                    
                    cell.imgView_item.sd_removeActivityIndicator()
                    
                    if error != nil {
                        print("Error code: \(error!.localizedDescription)")
                        cell.imgView_item.image = nil
                    } else {
                        cell.imgView_item.image = loadedImage
                        
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
                        self.tableView.endUpdates()
                    }
                }
            } else {
                cell.imgView_item.image = nil
            }
  
            cell.lbl_subTitle.numberOfLines = 0
            cell.lbl_title.numberOfLines = 0
            cell.imgView_item.contentMode = .scaleAspectFit
            cell.selectionStyle =  .none

            cell.lbl_title.text = model.title
            cell.lbl_subTitle.text = model.description
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


