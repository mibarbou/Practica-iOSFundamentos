//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 05/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation


//MARK : - Aliases
typealias JSONObject        =   AnyObject
typealias JSONDictionary    =   [String : JSONObject]
typealias JSONArray         =   [JSONDictionary]

//MARK: - Decodification
func decode(book json: JSONDictionary) throws  -> Book{
    
    guard let title = json["title"] as? String else {
        throw HackerBooksError.jsonParsingError
    }
    
    guard let authors = json["authors"] as? String,
        authorsArray = convertStringToArray(authors) else {
        throw HackerBooksError.jsonParsingError
    }
    
    guard let tags = json["tags"] as? String,
        tagsArray = convertStringToTagsArray(tags) else {
            throw HackerBooksError.jsonParsingError
    }
    
    guard let imageURL = json["image_url"] as? String,
        imgURL = NSURL(string: imageURL) else{
            throw HackerBooksError.wrongURLFormatForJSONResource
    }
    
    guard let pdfURL = json["pdf_url"] as? String,
        url = NSURL(string: pdfURL) else{
            throw HackerBooksError.wrongURLFormatForJSONResource
    }

   return Book(title: title, tags: tagsArray, authors: authorsArray, imageURL: imgURL, pdfURL: url)
 
}

func decode(book json: JSONDictionary?) throws -> Book{
    
    
    if case .Some(let jsonDict) = json{
        return try decode(book: jsonDict)
    }else{
        throw HackerBooksError.nilJSONObject
    }
}

//MARK: - Loading
func loadFrom(remoteURL url : String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray {
    guard let url = NSURL(string: url),
        data = NSData(contentsOfURL: url) else {
            throw HackerBooksError.jsonParsingError
    }
    let obj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
    
    if obj is JSONArray {
        guard let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
            array = maybeArray else {
                throw HackerBooksError.jsonParsingError
        }
        return array
    } else if obj is JSONDictionary {
        guard let maybeDictionary = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONDictionary,
            dictionary = maybeDictionary else {
                throw HackerBooksError.jsonParsingError
        }
        return [dictionary]
    } else {
        throw HackerBooksError.jsonParsingError
    }
}

func convertStringToTagsArray(string: String) -> [Tag]?{
    
    let array = string.componentsSeparatedByString(", ")
    var tagsArray = [Tag]()
    
    for tagString in array {
        
        tagsArray.append(Tag(name: tagString))
    }
    
    return tagsArray
}


func convertStringToArray(string: String) -> [String]? {
    
    let array = string.componentsSeparatedByString(", ")
    
    return array
}