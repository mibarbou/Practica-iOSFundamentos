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
    
    
    var booksCount: Int{
        get{
            let count = self.books.count
            return count
        }
    }
    
    init(books: [Book], tags: Set<Tag>){
        
        self.books = books
        self.tags = tags
    }
    
    func bookCountForTag(tag: String?) -> Int {
        
        return 0
    }
    
    func booksForTag(tag: String?) -> [Book]? {
        
        return [Book]()
    }
    
//    func bookAtIndex(index: Int) -> Book? {
//        
//        return Book()
//    }
    
}