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

func loadFromLocal() -> NSData? {

    let jsonPath = localJSONPath()
    
    var error : NSError?
    let fileExists = jsonPath.checkResourceIsReachableAndReturnError(&error)
    
    if fileExists {
        // tenemos el recurso cacheado en el directorio de documentos
        
        guard let data = NSData(contentsOfURL: jsonPath) else {
            
            return nil
        }
        
        return data

        
    } else {
        // descargamos el recurso con la url remota
        return nil
        
    }
}

func localJSONPath() -> NSURL {
    
    let jsonResource = "HackerBooks.json"
    
    let fm = NSFileManager.defaultManager()
    
    let docsPath = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    
    let filePath = docsPath.URLByAppendingPathComponent(jsonResource)
    
    return filePath
}

func loadFrom(remoteURL url : String) throws -> JSONArray {
    
    var obtainedData = NSData()
    if let theData = loadFromLocal(){
        
        obtainedData = theData
        
    } else {
        guard let url = NSURL(string: url),
            data = NSData(contentsOfURL: url) else {
                
                throw HackerBooksError.jsonParsingError
        }

        obtainedData = data
        
        let jsonPath = localJSONPath()
        
        obtainedData.writeToURL(jsonPath, atomically: true)
    }
    
    let object = try NSJSONSerialization.JSONObjectWithData(obtainedData, options: NSJSONReadingOptions.MutableContainers)
    
    if object is JSONArray {
        
        guard let maybeArray = try? NSJSONSerialization.JSONObjectWithData(obtainedData, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
            array = maybeArray else {
                
                throw HackerBooksError.jsonParsingError
        }
        return array
        
    } else if object is JSONDictionary {
        
        guard let maybeDictionary = try? NSJSONSerialization.JSONObjectWithData(obtainedData, options: NSJSONReadingOptions.MutableContainers) as? JSONDictionary,
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