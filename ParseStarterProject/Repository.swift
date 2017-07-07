//
//  Repository.swift
//  ParseStarterProject-Swift
//
//  Created by Yaateh on 7/3/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import Parse


protocol Repository  {
   associatedtype T
   
   //query for the event values based on user location or view location
   //store events locally
   //render the 
   
   func getAll() -> [T]
   func getById(id: Int) -> T
   func getByLocation(user: )
   
}
