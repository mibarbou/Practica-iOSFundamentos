//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 06/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    let model: Book
    
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
   
        syncModelWithView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func syncModelWithView() {
        
        titleLabel.text = model.title
        authorsLabel.text = model.authors.joinWithSeparator(", ")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            
            let imageData = NSData(contentsOfURL: self.model.imageURL)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let data = imageData {
                    
                    self.bookImageView.image = UIImage(data: data)
                } 
            })
        }
        
    }

}
