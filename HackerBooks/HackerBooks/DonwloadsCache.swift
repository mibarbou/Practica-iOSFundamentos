//
//  DonwloadsCache.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 08/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation
import UIKit

let ImageDidDownloadNotification = "Image did change"
let imageKey = "imageKey"

class AsyncImage {

    var url : NSURL
    
    var image : UIImage = UIImage(named: "BookPlaceholder")! {
        
        didSet{
      
            let notif = NSNotificationCenter.defaultCenter()
            notif.postNotificationName(ImageDidDownloadNotification, object: self, userInfo: [imageKey: image])
            
        }
    }
    
    init(url: NSURL) {
        
        self.url = url
        //self.image = UIImage(named: "BookPlaceHolder")!
        
        imageFor(url: self.url)
        
    }
    


     func imageFor(url url: NSURL) {

        let filePath = imagePathFor(url)
        
        var error : NSError?
        let fileExists = filePath.checkResourceIsReachableAndReturnError(&error)
        
        if fileExists {
            // tenemos el recurso cacheado en el directorio de documentos
            
            guard let data = NSData(contentsOfURL: filePath) else {
                
                return
            }
            
            guard let image = UIImage(data: data) else {
                
                return
            }

            self.image = image
            
        } else {
            // descargamos el recurso con la url remota
            downloadResource(url)
            
        }
        
    }
    
     func downloadResource(url: NSURL) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
 
            
            guard let data = NSData(contentsOfURL: url) else {
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                guard let image = UIImage(data: data) else {
                    
                    return
                }
                
                self.image = image
                
                let localImageUrl = self.imagePathFor(url)
                    
                data.writeToURL(localImageUrl, atomically: true)
      
            })
 
        }
    }
    
    
    func imagePathFor(url: NSURL) -> NSURL {
        
        let fm = NSFileManager.defaultManager()

        let docsPath = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
        

        let urlString =  url.absoluteString as NSString
        
        let imageName = urlString.componentsSeparatedByString("/").last!

        
        let filePath = docsPath.URLByAppendingPathComponent(imageName)
        
        return filePath
    }
    
}






