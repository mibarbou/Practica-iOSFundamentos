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
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
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
        
        let pdfButton = UIBarButtonItem(title: "Ver PDF", style: .Done, target: self, action: #selector(BookViewController.goToPdfView))
        
        navigationItem.rightBarButtonItem = pdfButton
        
        syncModelWithView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(imageDidDownload), name: ImageDidDownloadNotification, object: nil)
        nc.addObserver(self, selector: #selector(syncModelWithView), name: LibraryDidChangeNotification, object: nil)
   
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
    
    @IBAction func markOrUnmarkBookAsFavorite(sender: AnyObject) {
        
        if model.isFavorite {
            model.isFavorite = false
        } else {
            model.isFavorite = true
        }
        
        let favoriteID = String(model.pdfURL).componentsSeparatedByString("/").last!
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let favoritesArray = NSMutableArray()
        if let favorites = defaults.objectForKey(keyFavorites) as! NSArray! {
            
            let array = favorites.mutableCopy() as! NSMutableArray
            
            if !model.isFavorite {
                
                for i in 0..<array.count {
                    
                    if favoriteID != array.objectAtIndex(i) as? String {
                        
                        favoritesArray.addObject(favoriteID)
                    }
                }
                
            } else {
                
                favoritesArray.addObject(favoriteID)
            }
            
            
        } else {
            
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
        
        let tagsArray = Array(model.tags)
        var tagsNameArray = [String]()
        for t in tagsArray {
            
            tagsNameArray.append(t.name)
        }
        tagsLabel.text = tagsNameArray.joinWithSeparator(" - ")
        
        
        if model.isFavorite {
            
            favoriteButton.setImage(UIImage(named: "favoriteOn"), forState: .Normal)
            
        } else {
            
            favoriteButton.setImage(UIImage(named: "favoriteOff"), forState: .Normal)
        }
        
        bookImageView.image = AsyncImage(url: model.imageURL).image
        
        
        
    }
    
    func libraryViewController(vc: LibraryTableViewController, didSelectCharacter book: Book) {
        
        
        model = book
        
        syncModelWithView()
    }

}













