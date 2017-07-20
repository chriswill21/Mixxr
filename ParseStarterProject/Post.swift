//
//  Post.swift
//  ParseStarterProject-Swift
//
//  Created by Bamlak Gessessew on 7/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import Parse


class Post: NSObject {
    
    class func userPost(caption: String?, withImage image: UIImage?, withDate date: Date?, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: "Post")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DMMM d, yyyy"
        let date = dateFormatter.string(from: date!)
        
        //Add relevant fields to the object
        post["media"] = getPFFileFromImage(image: image) //PFFile column type
        post["user"] = PFUser.current()
        post["caption"] = caption
        post["likes"] = 0
        post["date"] = date
        
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
        
    }
    
    class func userInterestedPost(eventInterest: PFObject, title: String?,completion: PFBooleanResultBlock?) {
        let post = PFObject(className: "Post")
        
        post["user"] = PFUser.current()
        post["action"] = "is interested in"
        post["event"] = eventInterest
        
        
        post.saveInBackground(block: completion)
    }
    
    class func orgCreatePost(eventCreated: PFObject, title: String?,completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: "Post")
        
        post["user"] = PFUser.current()
        post["action"] = "created event"
        post["event"] = eventCreated
        
        
        post.saveInBackground(block: completion)
    }
    
    
    
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if var image = image {
            image = resize(image: image, newSize: CGSize(width: 200, height: 125))
            //get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
