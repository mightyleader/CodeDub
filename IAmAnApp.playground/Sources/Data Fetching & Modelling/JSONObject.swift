//
//  JSONObject.swift
//  CodeDub
//
//  Created by Rob Stearn on 28/11/2015.
//  Copyright © 2015 mostgood. All rights reserved.
//

import Foundation

public enum JSONObject
{
    //Case for each support object type in the JSON standard
    case JSONArray([AnyObject])
    case JSONDictionary([Swift.String: AnyObject])
    case JSONString(Swift.String)
    case JSONNumber(Swift.Float)
    case JSONNull
    
    public static func parse(data: NSData) -> JSONObject?
    {
        do
        {
            let json: AnyObject = try JSONSerialization.jsonObject(with: (data as NSData) as Data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
            
            return wrapObjectIntoJSONObject(objectToWrap: json)
        }
        catch
        {
            return nil
        }
    }
    
    
    public static func wrapObjectIntoJSONObject(objectToWrap: AnyObject?) -> JSONObject
    {
        if let stringObject = objectToWrap as? Swift.String
        {
            return .JSONString(stringObject)
        }
        
        if let numberObject = objectToWrap as? NSNumber
        {
            return .JSONNumber(numberObject.floatValue)
        }
        
        if let dictionaryObject = objectToWrap as? [Swift.String: AnyObject]
        {
            return .JSONDictionary(dictionaryObject as [Swift.String: AnyObject])
        }
        
        if let arrayObject = objectToWrap as? [AnyObject]
        {
            return .JSONArray(arrayObject as [AnyObject])
        }
        //Did you pass in an NSNull value? Bad, very bad! ;)
        assert(objectToWrap is NSNull, "Unsupported Type of NSNull passed.")
        return .JSONNull
    }
    
    
    public var string: Swift.String?
    {
        switch self
        {
            case .JSONString(let stringValue):
                return stringValue
            default:
                return nil
        }
    }
    
    public var int: Int?
    {
        switch self
        {
            case .JSONNumber(let numberValue):
                return Int(numberValue)
            default:
                return nil
        }
    }
    
    public var float: Float?
    {
        switch self
        {
            case .JSONNumber(let numberValue):
                return numberValue
            default:
                return nil
        }
    }
    
    public var bool: Bool?
    {
        switch self
        {
            case .JSONNumber(let booleanValue):
                return (booleanValue != 0)
            default:
                return nil
        }
    }
    
    public var isNull: Bool
    {
        switch self
        {
            case .JSONNull:
                return true
            default:
                return false
        }
    }
    
    public var dictionary: [Swift.String: JSONObject]?
        {
            switch self
            {
                case .JSONDictionary(let dictionaryObject):
                    var jsonObject: [Swift.String: JSONObject] = [:]
                    for (key,value) in dictionaryObject
                    {
                        jsonObject[key] = JSONObject.wrapObjectIntoJSONObject(objectToWrap: value)
                    }
                    return jsonObject
                default:
                    return nil
            }
    }
    
    public var array: [JSONObject]?
        {
            switch self
            {
                case .JSONArray(let array):
                    let jsonArray = array.map(
                        {
                            JSONObject.wrapObjectIntoJSONObject(objectToWrap: $0)
                        }
                    )
                    return jsonArray
                default:
                    return nil
            }
    }
    
    public subscript(index: Swift.String) -> JSONObject?
        {
            switch self
            {
                case .JSONDictionary(let dictionary):
                    if let value = dictionary[index]
                    {
                        return JSONObject.wrapObjectIntoJSONObject(objectToWrap: value)
                    }
                    fallthrough
                default:
                    return nil
            }
    }
    
    public subscript(index: Int) -> JSONObject?
        {
            switch self
            {
                case .JSONArray(let array):
                    let castArrayValue = array[index]
                    return JSONObject.wrapObjectIntoJSONObject(objectToWrap: castArrayValue)
                default:
                    return nil
            }
    }
}

