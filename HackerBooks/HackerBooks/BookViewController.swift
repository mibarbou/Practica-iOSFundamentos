//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 06/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import UIKit

let keyFavorites = "key favorites user defaults"

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
        
        let pdfButton = UIBarButtonItem(title: "PDF", style: .Done, target: self, action: #selector(BookViewController.goToPdfView))
        
        let favoriteButton = UIBarButtonItem(title: "Favorito", style: .Done, target: self, action: #selector(BookViewController.markBookAsFavorite))
        
        navigationItem.rightBarButtonItems = [pdfButton, favoriteButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(imageDidDownload), name: ImageDidDownloadNotification, object: nil)
   
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
    
    func imageDidDownload(notification: NSNotification)  {

        syncModelWithView()
        
    }
    
    
    func goToPdfView() {
        
        let pdfVC = PdfViewController(model: self.model)
        navigationController?.pushViewController(pdfVC, animated: true)
        
    }
    
    func markBookAsFavorite() {
        
        if model.isFavorite {
            model.isFavorite = false
        } else {
            model.isFavorite = true
        }
        
        let favoriteID = String(model.pdfURL).componentsSeparatedByString("/").last!
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let favoritesArray : NSMutableArray
        if let favorites = defaults.objectForKey(keyFavorites) as! NSArray! {
            
            favoritesArray = favorites.mutableCopy() as! NSMutableArray
            
            if !model.isFavorite {
                
                for i in 0..<favoritesArray.count{
                    
                    if favoriteID == favoritesArray.objectAtIndex(i) as? String {
                        
                        favoritesArray.removeObjectAtIndex(i)
                    }
                }
                
            } else {
                
                favoritesArray.addObject(favoriteID)
            }
            
            
        } else {
            favoritesArray = NSMutableArray()
            
            if model.isFavorite {
                
                favoritesArray.addObject(favoriteID)
            }
        }
        
        defaults.setObject(favoritesArray, forKey: keyFavorites)
        defaults.synchronize()

    }
    

    func syncModelWithView() {
        
        titleLabel.text = model.title
        authorsLabel.text = model.authors.joinWithSeparator(", ")
        
        bookImageView.image = AsyncImage(url: model.imageURL).image
        
    }
    
    func libraryViewController(vc: LibraryTableViewController, didSelectCharacter book: Book) {
        
        
        model = book
        
        syncModelWithView()
    }

}













