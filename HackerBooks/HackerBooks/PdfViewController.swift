//
//  PdfViewController.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 06/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {

    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: Book
    
    init(model: Book){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(bookDidChange), name: BookDidChangeNotification, object: nil)
        nc.addObserver(self, selector: #selector(syncModelWithView), name: RersourceDidDownloadNotification, object: nil)
        
        syncModelWithView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bookDidChange(notification: NSNotification)  {
        
        let info = notification.userInfo!
        
        let book = info[BookKey] as? Book
        
        model = book!
        
        syncModelWithView()
        
    }
    

    func syncModelWithView() {

        activityIndicator.startAnimating()
        
        if let data = AsyncResource(resourceURL: model.pdfURL).data {
            
            self.activityIndicator.stopAnimating()
            
            self.pdfView.loadData(data, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: self.model.pdfURL)
            
        }
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            
//            let pdfData = NSData(contentsOfURL: self.model.pdfURL)
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                if let data = pdfData {
//                    
//                    self.activityIndicator.stopAnimating()
//                    
//                    self.pdfView.loadData(data, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: self.model.pdfURL)
//                }
//            })
//        }
        
    }

}
