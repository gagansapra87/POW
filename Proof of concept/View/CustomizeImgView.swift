//
//  CustomizeImgView.swift
//  Proof of concept
//
//  Created by ant-love-mac on 25/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

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
