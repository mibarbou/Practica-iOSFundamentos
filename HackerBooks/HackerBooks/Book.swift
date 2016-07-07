//
//  Book.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 05/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation


class Book : Comparable {
    
    let title       :   String
    let tags        :   [Tag]
    let authors     :   [String]
    let imageURL    :   NSURL
    let pdfURL      :   NSURL
    let isFavorite  : Bool
    
    
    init(title: String, tags: [Tag], authors: [String], imageURL: NSURL, pdfURL: NSURL, isFavorite: Bool = false){
        
        self.title = title
        self.tags = tags
        self.authors = authors
        self.imageURL = imageURL
        self.pdfURL = pdfURL
        self.isFavorite = isFavorite
    }
    
    var proxyForComparison : String{
        get{
            return "\(title)\(authors)"
        }
    }
    
    var proxyForSorting : String{
        get{
            return proxyForComparison
        }
    }
    
}

extension Book: Hashable{
    
    var hashValue : Int {
        get {
            return "\(title),\(authors)".hashValue
        }
    }
}


//MARK: - Equatable & Comparable
func ==(lhs: Book, rhs: Book) -> Bool{
    
    guard (lhs !== rhs) else{
        return true
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: Book, rhs: Book) -> Bool{
    return lhs.proxyForSorting < rhs.proxyForSorting
}


extension Book :  CustomStringConvertible{
    
    var description : String{
        get{

            return  "<\(self.dynamicType)\(title) -- \(authors)>"
            
        }
    }
    
}
