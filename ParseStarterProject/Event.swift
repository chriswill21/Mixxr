//
//  Event.swift
//  ParseStarterProject-Swift
//
//  Created by Bamlak Gessessew on 7/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse


class Event: NSObject {
    
    class func postEvent(image: UIImage?, title: String?, description: String?, location: String?, startDate: NSDate?, start: String?, endDate: NSDate?, end: String?, jobs: String, withCompletion completion: PFBooleanResultBlock?) {
        
        let event = PFObject(className: "Event")
        
        event["authorId"] = PFUser.current()?.objectId!
        event["title"] = title
        event["banner"] = getPFFileFromImage(image: image)
        event["description"] = description
        event["author"] = PFUser.current()
        event["location"] = location
        event["start"] = start
        event["start_date"] = startDate
        event["end"] = end
        event["end_date"] = endDate
        event["completed"] = false
        event["hiring"] = true
        event["guests"] = 0
        event["pending_count"] = 0
        event["expected_tasks"] = jobs
        event["pending_guests"] = []
        event["accepted_guestss"] = []
        //event["goals"] = goals
        //TODO: event sponsors & other event properties
        
        event.saveInBackground(block: completion)
        
//        Post.orgCreatePost(eventCreated: event, title: title) { (success: Bool, error: Error?) in
//            if success {
//                print("createPost created")
//            } else {
//                print(error?.localizedDescription ?? "error")
//            }
//        }
    }
    
    
    
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image, let imageData = UIImagePNGRepresentation(image) {
            return PFFile(name: "image.png", data: imageData)
        }
        
        return nil
        
    }
    
}
