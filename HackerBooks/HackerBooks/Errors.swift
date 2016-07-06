//
//  Errors.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 06/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import Foundation

// MARK: JSON Errors
enum HackerBooksError : ErrorType{
    
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
}