//
//  Library.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 05/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation

let LibraryDidChangeNotification = "Library model did change"

typealias BooksArray = [Book]
typealias LibraryDictionary = [Tag : Set<Book>]

class Library {
    
    var books   :   [Book]
    var tags    :   Set<Tag>
    
    var dict : LibraryDictionary = LibraryDictionary()
    
    var booksCount: Int{
        get{
            let count = self.books.count
            return count
        }
    }
    
    var orderByTags : Bool {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName(LibraryDidChangeNotification, object: self, userInfo: nil)
        }
    }
    
    var tagsCount: Int{
        get{
            let count = self.tags.count
            return count
        }
    }
    
    init(books: [Book], tags: Set<Tag>){
        
        self.books = books
        self.tags = tags
        self.orderByTags = false
        
        putBooksByTags()
        
        let notif = NSNotificationCenter.defaultCenter()
        notif.addObserver(self, selector: #selector(updateModel), name: BookFavoriteDidChangenotification, object: nil)
     
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func updateModel(){
    
        putBooksByTags()
        
        NSNotificationCenter.defaultCenter().postNotificationName(LibraryDidChangeNotification, object: self, userInfo: nil)
    }
    
    func sectionCount() -> Int {
        
        if !self.orderByTags {
            
            return 1
        } else {
            
            return tagsCount
        }
    }
    
    
    func bookCountForTag(tag: Tag?) -> Int {
        
        guard let theTag = tag,
            count = dict[theTag]?.count else {
            return 0
        }

        return count
    }
    
    func booksForTag(tag: Tag) -> [Book]? {
        
        guard let booksSet = dict[tag] else {
            return nil
        }
        
        return Array(booksSet)
    }
    
//    func bookAtIndex(index: Int) -> Book? {
//        
//        return Book()
//    }
    
    
    func bookHasTag(tag: Tag, inTags tags: [Tag]) -> Bool {
        
        for theTag in tags {
            
            if tag == theTag{
                return true
            }
        }
        
        return false
        
    }
    
    func getBooksAtIndex(index: Int) -> [Book]? {
        
        if !orderByTags {
            
            return getBooksOrderedByTitle(self.books)
            
        } else {
        
            let tagsArray = getOrderedTagsArray()
            
            guard let books = self.booksForTag(tagsArray[index]) else {
                return nil
            }
            
            return getBooksOrderedByTitle(books)
        }
    }
    
    func getBookAtIndexPath(indexPath: NSIndexPath) -> Book? {
        
        guard let book = getBooksAtIndex(indexPath.section)?[indexPath.row] else {
            return nil
        }
        
        return book
    }
    
    func getTagNameAtIndex(index: Int) -> String {
        
        if !orderByTags {
            
            return ""
            
        } else {
        
            let tagsArray = getOrderedTagsArray()
            
            if tagsArray[index].name == "favorites" && bookCountForTag(Tag(name: "favorites")) == 0 {
                return ""
            }
     
            return (tagsArray[index].name).uppercaseString
            
        }
    }
    
    //MARK: Utils
    func makeEmptyTagsDictionary() -> LibraryDictionary {
        
        var d = LibraryDictionary()
        
        for t in self.tags {
            
            d[t] = Set<Book>()
        }
        return d
    }
    
    func putBooksByTags(){
        
        dict = makeEmptyTagsDictionary()
        
        let favoriteTag = Tag(name: "favorites")
        tags.insert(favoriteTag)
        
        for book in books {
            
            if book.isFavorite {
                
                dict[favoriteTag]?.insert(book)
            }
            
            for tag in book.tags {
                
                if (tags.contains(tag)){
                    
                    dict[tag]?.insert(book)
                }
            }
        }
    }
    
    func getBooksOrderedByTitle(books: [Book]) -> [Book]{
        
        return books.sort({$0.title < $1.title})
    }
    
    func getOrderedTagsArray() -> [Tag]{
        
        let tagsSet = self.tags
        var tagsArray = Array(tagsSet)
        tagsArray.sortInPlace({ $0.name < $1.name })
        
        var finalArray = [Tag]()
        for t in tagsArray{
            
            if t.name == "favorites" {
                finalArray.insert(t, atIndex: 0)
            } else {
                finalArray.append(t)
            }
        }
        
        return finalArray
    }
    
}