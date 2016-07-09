//
//  Library.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 05/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation

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
    
    var tagsCount: Int{
        get{
            let count = self.tags.count
            return count
        }
    }
    
    init(books: [Book], tags: Set<Tag>){
        
        _ = NSNotificationCenter.defaultCenter()
//        nc.addObserver(self, selector: #selector(imageDidDownload), name: BookFavoriteDidChangenotification, object: nil)
        
        self.books = books
        self.tags = tags
        
        dict = makeEmptyTagsDictionary()
        
        for book in books {
            
            for tag in book.tags {
            
                if (tags.contains(tag)){
                    
                    dict[tag]?.insert(book)
                }
                
                if book.isFavorite {
                    let favoriteTag = Tag(name: "favorites")
                    dict[favoriteTag]?.insert(book)
                }
            }
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
        
        let tagsArray = getOrderedTagsArray()
        
        guard let books = self.booksForTag(tagsArray[index]) else {
            return nil
        }
        
        return getBooksOrderedByTitle(books)
    }
    
    func getBookAtIndexPath(indexPath: NSIndexPath) -> Book? {
        
        guard let book = getBooksAtIndex(indexPath.section)?[indexPath.row] else {
            return nil
        }
        
        return book
    }
    
    func getTagNameAtIndex(index: Int) -> String {
        
        let tagsArray = getOrderedTagsArray()
        
        if tagsArray[index].name == "favorites" && bookCountForTag(Tag(name: "favorites")) == 0 {
            return ""
        }
 
        return (tagsArray[index].name).uppercaseString
    }
    
    //MARK: Utils
    func makeEmptyTagsDictionary() -> LibraryDictionary {
        
        var d = LibraryDictionary()
        
        for t in self.tags {
            
            d[t] = Set<Book>()
        }
   
        return d
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