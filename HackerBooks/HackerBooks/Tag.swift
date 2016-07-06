//
//  Tag.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 06/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation


class Tag {
    
    let name : String
    
    init(name: String){
        
        self.name = name
    }
}


extension Tag: Hashable{
    
    var hashValue : Int {
        get {
            return "\(name)".hashValue
        }
    }
}

func ==(lhs: Tag, rhs: Tag) -> Bool{
    
    guard (lhs !== rhs) else{
        return true
    }
    
    return lhs.name == rhs.name
}