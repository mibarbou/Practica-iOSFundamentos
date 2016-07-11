//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 06/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    let model: Library
    var segmentedControl : UISegmentedControl?
    
    weak var delegate : LibraryViewControllerDelegate?
    
    init(model: Library){
        self.model = model
        
        segmentedControl = UISegmentedControl(items: ["ABC", "TAG"])
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hackers Books"
        
        getSavedData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        drawSegmentedControl()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(reloadTable), name: ImageDidDownloadNotification, object: nil)
        nc.addObserver(self, selector: #selector(reloadTable), name: LibraryDidChangeNotification, object: nil)
  
    }
    
    func getSavedData() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let favoritesArray = defaults.objectForKey(keyFavorites) as! NSArray! {
            
            for book in model.books {
                
                for id in favoritesArray {
                    
                    let bookID = String(book.pdfURL).componentsSeparatedByString("/").last!
                    
                    if bookID == id as! String {
                        
                        book.isFavorite = true
                    }
                }
            }
        }
        
        tableView.reloadData()
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
    
    //MARK: Segmented Control Methods
    func segmentedControlTapped(sender: UISegmentedControl)  {
        
        switch sender.selectedSegmentIndex {
        case 0:
            model.orderByTags = false
        default:
            model.orderByTags = true
        }
    }
    
    func drawSegmentedControl()  {
        
        if let nav = navigationController?.navigationBar {
            
            if model.orderByTags {
                
                segmentedControl?.selectedSegmentIndex = 1
                
            } else {
                
                segmentedControl?.selectedSegmentIndex = 0
            }
            
            segmentedControl!.frame = CGRect(x: nav.frame.size.width - 80, y: 5, width: 70, height: 30)
            
            segmentedControl?.addTarget(self, action: #selector(segmentedControlTapped), forControlEvents: .ValueChanged)
            
            
            nav.addSubview(segmentedControl!)
        }
    }
    
    
    func reloadTable(notification: NSNotification)  {
        
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
   
        return model.sectionCount()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let books = model.getBooksAtIndex(section) else {
            
            return 0
        }
        
        return books.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "BookCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            // El optional está vacío: hay que crearla a pelo
            cell = UITableViewCell(style: .Subtitle,
                                   reuseIdentifier: cellId)
        }

        let book = model.getBookAtIndexPath(indexPath)!
        
        cell?.textLabel?.text = book.title
        cell?.imageView?.image = AsyncImage(url: book.imageURL).image
        cell?.detailTextLabel?.text = book.authors.joinWithSeparator(", ")

        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return model.getTagNameAtIndex(section)
    }
    
    //MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let book = model.getBookAtIndexPath(indexPath)!
        
        delegate?.libraryViewController(self, didSelectCharacter: book)
        
        
        if let bookVC = self.delegate as? BookViewController {
            
//            splitViewController?.showDetailViewController(bookVC, sender: nil)
            
            if let bookNAV = bookVC.navigationController {
                
                splitViewController?.showDetailViewController(bookNAV, sender: nil)
            }
            
        }
        
//        let bookVC = BookViewController(model: book)
//        
//        navigationController?.pushViewController(bookVC, animated: true)
        
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        return true
    }

}


protocol LibraryViewControllerDelegate: class {
    
    func libraryViewController(vc : LibraryTableViewController, didSelectCharacter book: Book)
}
















