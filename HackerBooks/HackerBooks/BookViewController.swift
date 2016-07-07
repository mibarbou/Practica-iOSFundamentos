//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 06/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, LibraryViewControllerDelegate{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
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
        
        syncModelWithView()
        
        let pdfButton = UIBarButtonItem(title: "Ver PDF", style: .Done, target: self, action: #selector(BookViewController.goToPdfView))
        navigationItem.rightBarButtonItem = pdfButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToPdfView() {
        
        let pdfVC = PdfViewController(model: self.model)
        navigationController?.pushViewController(pdfVC, animated: true)
        
    }
    

    func syncModelWithView() {
        
        titleLabel.text = model.title
        authorsLabel.text = model.authors.joinWithSeparator(", ")
        
        bookImageView.image = UIImage()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            
            let imageData = NSData(contentsOfURL: self.model.imageURL)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let data = imageData {
                    
                    self.bookImageView.image = UIImage(data: data)
                } 
            })
        }
        
    }
    
    func libraryViewController(vc: LibraryTableViewController, didSelectCharacter book: Book) {
        
        
        model = book
        
        syncModelWithView()
    }

}


//extension BookViewController: LibraryViewControllerDelegate{
//    
//    func libraryViewController(vc: LibraryTableViewController, didSelectCharacter book: Book) {
//        
//        
//        model = book
//        
//        syncModelWithView()
//    }
//}












