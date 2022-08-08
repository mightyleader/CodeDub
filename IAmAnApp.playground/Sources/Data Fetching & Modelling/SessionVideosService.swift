//
//  SessionVideosService.swift
//  CodeDub
//
//  Created by Rob Stearn on 26/11/2015.
//  Copyright © 2015 mostgood. All rights reserved.
//

import Foundation

//Publicly accessible type for the completion handler for Session Model Receiving and Parsing
typealias SessionVideoCompletion = ((_ sessionObject: [SessionVideoModel], _ error: NSError?) -> Void)?

class SessionVideosService
{
    class func fetchSessionsFromServer(completion: SessionVideoCompletion) -> Void
    {
        let url      = NSURL(string: Resources().sessionVideoURLString)
        let request  = NSURLRequest(url: url! as URL)
        
        let config   = URLSessionConfiguration.default
        let session  = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: request as URLRequest)
        {
            (data: Data?,response: URLResponse?, error: Error?) -> Void in
             if ( data != nil )
             {
                SessionVideosService.parseData(data: data! as NSData, completion: completion)
             }
            else
             {
                let noSessions: [SessionVideoModel] = []
                completion!(noSessions, error! as NSError)
            }
                
        }
        
        dataTask.resume()
    }
    
    private class func parseData(data: NSData,
                                 completion: SessionVideoCompletion) -> Void
    {
        // parse object into models
        let jsonObject = JSONObject.parse(data: data)
        let modelsArray = SessionVideoParser.sessionVideoModelsFromJSONObject(receivedJSON: jsonObject!)
        completion!(modelsArray, nil)

    }
}
