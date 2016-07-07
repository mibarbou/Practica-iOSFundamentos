//
//  Library.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 05/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation

typealias BooksArray = [Book]
typealias LibraryDictionary = [String : Set<Book>]

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
        
        self.books = books
        self.tags = tags
        
        dict = makeEmptyTagsDictionary()
        
        for book in books {
            
            for tag in book.tags {
            
                if (tags.contains(tag)){
                    
                    dict[tag.name]?.insert(book)
                }
            }
        }
        
    }
    
    
    func bookCountForTag(tag: Tag?) -> Int {
        
        guard let theTag = tag,
            count = dict[theTag.name]?.count else {
            return 0
        }

        return count
    }
    
    func booksForTag(tag: Tag) -> [Book]? {
        
        guard let booksSet = dict[tag.name] else {
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
 
        return (tagsArray[index].name).uppercaseString
    }
    
    //MARK: Utils
    func makeEmptyTagsDictionary() -> LibraryDictionary {
        
        var d = LibraryDictionary()
        
        for t in self.tags {
            
            d[t.name] = Set<Book>()
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
        
        return tagsArray
    }
    
}