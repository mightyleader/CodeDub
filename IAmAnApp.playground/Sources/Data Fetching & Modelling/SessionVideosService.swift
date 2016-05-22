//
//  SessionVideosService.swift
//  CodeDub
//
//  Created by Rob Stearn on 26/11/2015.
//  Copyright © 2015 mostgood. All rights reserved.
//

import Foundation

//Publicly accessible type for the completion handler for Session Model Receiving and Parsing
typealias SessionVideoCompletion = ((sessionObject: [SessionVideoModel], error: NSError?) -> Void)?

class SessionVideosService
{
    class func fetchSessionsFromServer(completion: SessionVideoCompletion) -> Void
    {
        let url      = NSURL(string: Resources().sessionVideoURLString)
        let request  = NSURLRequest(URL: url!)
        
        let config   = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session  = NSURLSession(configuration: config)
        
        let dataTask = session.dataTaskWithRequest(request)
        {
            (data: NSData?,response: NSURLResponse?, error: NSError?) -> Void in
             if ( data != nil )
             {
                SessionVideosService.parseData(data!, completion: completion)
             }
            else
             {
                let noSessions: [SessionVideoModel] = []
                completion!(sessionObject: noSessions, error: error!)
            }
                
        }
        
        dataTask.resume()
    }
    
    private class func parseData(data: NSData,
                                 completion: SessionVideoCompletion) -> Void
    {
        // parse object into models
        let jsonObject = JSONObject.parse(data)
        let modelsArray = SessionVideoParser.sessionVideoModelsFromJSONObject(jsonObject!)
		completion!(sessionObject: modelsArray, error: nil)

    }
}