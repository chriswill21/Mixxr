////
////  Repository.swift
////  ParseStarterProject-Swift
////
////  Created by Yaateh on 7/3/17.
////  Copyright © 2017 Parse. All rights reserved.
////
//
//import Foundation
//import Parse
//import CoreLocation
//
//
//
//// we could also use open class Repository<Entity: PFObject>
//// I think protocols are slightly easier to replicate
//
//protocol Repository  {
//    associatedtype Entity
//    
//   
//   //query for the event values based on user location or view location
//   //store events locally
//   //render the
//    init()
//    //getters
//    func getAll(cache: Bool? ) -> [Entity]
//    func getById(id: Int, cache: Bool?) -> Entity
//    func getByLocation(location: PFGeoPoint, cache: Bool?) -> [Entity]
//    func getByLatLon(lat: Double, lon: Double, cache: Bool?) -> [Entity]
//    func getByCLLocation()//stub
//
//    //Create Update Delete
//    func updateById(id: Int) -> Bool
//    
//    func create(object: Entity) -> Bool
//    
//    func deleteById(id: Int)
//}
//
//class EventRepository: Repository   {
//    typealias Entity = PFObject
//
//    private var _user:PFUser
//    private var _locManager:CLLocationManager
////    private var _query: PFQuery
//    
//    required init(){
//        
//        self._user = PFUser.current()!
//        self._locManager = CLLocationManager()
////        self._query = PFQuery(className: "Event")
//        
//    }
//    //getters
//    @discardableResult func getAll(cache: Bool? ) -> [Entity] {
//        var query = PFQuery(className: "Event")
//    }
//    func getById(id: Int, cache: Bool?) -> Entity {
//        
//    }
//    @discardableResult func getByLocation(location: PFGeoPoint, cache: Bool?) -> [Entity] {
//        
//    }
//    @discardableResult func getByLatLon(lat: Double, lon: Double, cache: Bool?) -> [Entity] {
//        
//    }
//    func getByCLLocation(){
//        
//    }//stub
//    
//    //Create Update Delete
//    func updateById(id: Int) -> Bool {
//        
//    }
//    
//    func create(object: Entity) -> Bool {
//        
//    }
//    
//    func deleteById(id: Int) -> Bool {
//        
//    }
//}
//
//
