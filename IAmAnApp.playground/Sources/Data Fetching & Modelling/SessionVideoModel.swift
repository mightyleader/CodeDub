//
//  SessionVideoModel.swift
//  CodeDub
//
//  Created by Rob Stearn on 26/11/2015.
//  Copyright © 2015 mostgood. All rights reserved.
//

/// Models the data for a WWDC Session Video
class SessionVideoModel
{
	let sessionID: String
	let dateString: String
	let title: String
	let track: String
	let description: String
	let focuses: [String]
	let streamString: String
	
	/**
	Creates a complete and immutable instance of the class. All parameters accept a value or nil,
	
	- parameter date:         The year the session was originally presented, in YYYY format.
	- parameter title:        The short title of the session.
	- parameter track:        The track the session was presented as part of.
	- parameter description:  The full description of the session.
	- parameter focuses:      An array of the platforms covered in the session.
	- parameter streamString: The string value of the URL where the video can be streamed from.
	
	- returns: A fully instantied immutable model object of the class.
	*/
	init(sessionID: String = "0",
			  date: String = "0",
		     title: String = "untitled",
		     track: String = "",
       description: String = "",
	       focuses: [String] = [],
      streamString: String = "")
	{
		self.sessionID = sessionID
		self.dateString = date
		self.title = title
		self.track = track
		self.description = description
		self.focuses = focuses
		self.streamString = streamString
	}
}