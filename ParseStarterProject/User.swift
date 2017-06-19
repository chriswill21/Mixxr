//
//  User.swift
//  ParseStarterProject-Swift
//
//  Created by Mateo Correa on 5/31/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

class User {
    var username: String = ""
    var password: String = ""
    var groups: [String] = []
    var followers: Int = 0
    
    
    
    func getFollowerCount() -> Int {
        return 0
    }
    
    func getFollowers() -> [String] {
        return []
    }
    
    func getEventsAttended() -> [String] {
        return []
    }
}
