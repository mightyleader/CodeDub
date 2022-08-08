//
//  SessionModelParser.swift
//  CodeDub
//
//  Created by Rob Stearn on 26/11/2015.
//  Copyright © 2015 mostgood. All rights reserved.
//

import Foundation

class SessionVideoParser
{
    class func sessionVideoModelsFromJSONObject(receivedJSON: JSONObject) -> [SessionVideoModel]
    {
        if let rootObject = receivedJSON.dictionary {
            //Can't chain optionals whose creation is the previous step :(
            if let sessions: JSONObject = rootObject["sessions"] {
                if let theArray = sessions.array {
                    let modelArray = theArray.map({
                        (session: JSONObject) -> SessionVideoModel in
                        //Optional Chain for as many fields as possible
                        if let title  = session.dictionary!["title"]?.string,
                          let track   = session.dictionary!["track"]?.string,
                          let desc    = session.dictionary!["description"]?.string,
                          let stream  = session.dictionary!["url"]?.string
                        {
                            //Optional Chaining only works for fields that always have a value
                            let date = String(session.dictionary!["year"]?.int! ?? 2022)
                            let id   = String((session.dictionary!["id"]?.int!)!)

                            //Create the model object from JSONObject
                            let model = SessionVideoModel(sessionID: id,
                                                               date: date,
                                                              title: title,
                                                              track: track,
                                                        description: desc,
                                                       streamString: stream)
                            
                            return model
                        }
                        return SessionVideoModel()
                    })
                    
                    return modelArray
                }
            }
        }
        return []
    }
    
    
}
