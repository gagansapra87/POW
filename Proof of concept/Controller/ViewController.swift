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
        
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: textCellIndetifier)
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)

        refresh.addTarget(self, action: #selector(fetchWeatherData), for: .valueChanged)
        refresh.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresh.attributedTitle = NSAttributedString.init(string: REFRESH)
        self.tableView.refreshControl = refresh
        
        tableView.frame = self.view.frame
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModelClass.getAllDataAPI(vc: self) { (data) in
            
            DispatchQueue.main.async {
                
                self.arr_data = data
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    //MARK: RefreshDataMethod
    
    @objc private func fetchWeatherData() {
        
        viewModelClass.getAllDataAPI(vc: self) { (data) in
            DispatchQueue.main.async {
                self.arr_data = data
                self.tableView.reloadData()
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: textCellIndetifier) as! TableViewCell
            let model = arr_data[indexPath.row]
            
            if let urlString  = URL.init(string: model.imageHref) {
                
                cell.imgView_item.sd_setIndicatorStyle(.white)
                cell.imgView_item.sd_setShowActivityIndicatorView(true)
                cell.imgView_item.sd_setImage(with: urlString) { (loadedImage, error, cacheType, url) in
                    
                    cell.imgView_item.sd_removeActivityIndicator()
                    
                    if error != nil {
                        print("Error code: \(error!.localizedDescription)")
                    } else {
                        cell.imgView_item.image = loadedImage
                        
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
                        self.tableView.endUpdates()
                    }
                }
            }
  
            cell.lbl_subTitle.numberOfLines = 0
            cell.lbl_title.numberOfLines = 0
            cell.selectionStyle =  .none

            cell.lbl_title.text = model.title
            cell.lbl_subTitle.text = model.description
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class CustomizeImgView : UIImageView {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            
            if data != nil {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    self.imageCache.setObject(imageToCache ?? UIImage(), forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
            }.resume()
    }
}


