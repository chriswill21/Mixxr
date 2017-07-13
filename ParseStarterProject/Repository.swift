// //
// //  Repository.swift
// //  ParseStarterProject-Swift
// //
// //  Created by Yaateh on 7/3/17.
// //  Copyright © 2017 Parse. All rights reserved.
// //

// import Foundation
// import Parse
// import CoreLocation



// // we could also use open class Repository<Entity: PFObject>
// // I think protocols are slightly easier to replicate

// protocol Repository  {
//     associatedtype Entity
    
   
//    //query for the event values based on user location or view location
//    //store events locally
//    //render the
//     init()
//     //getters
//     func getAll(cache: Bool? ) -> [Entity]
//     func getById(id: String, cache: Bool?) -> Entity
//     func getByLocation(location: PFGeoPoint, cache: Bool?) -> [Entity]
//     func getByLatLon(lat: Double, lon: Double, cache: Bool?) -> [Entity]
//     func getByCLLocation()//stub

//     //Create Update Delete
//     func updateById(id: String) -> Bool
    
//     func create(object: Entity) -> Bool
    
//     func deleteById(id: String)
// }

// class EventRepository: Repository   {
//     typealias Entity = PFObject

//     private var _user:PFUser
//     private var _locManager:CLLocationManager
//     private var eventsInitialized: Bool;
// //    private var _query: PFQuery
    
//     required init(){
//         self.eventsInitialized = false
//         self._user = PFUser.current()!
//         self._locManager = CLLocationManager()// we might want to consider injecting the repo class into a bigger one and letting that one manage, update adn refresh user location
// //        self._query = PFQuery(className: "Event")
        
//     }
//     //getters
//     @discardableResult func getAll(cache: Bool? ) -> [Entity]? {
//         let query = PFQuery(className: "Event")
//         var results = [Entity]()
//         query.findObjectsInBackground(block: { (objects, error) in
//             if error == nil {
//                 results = objects // todo: Implemetn comparator in Parse to sort by location
//             }
//             else {
//                 print("Error: \(error!)")
//             }
//         })
//         if (!results.isEmpty){
//             return results
//         }
//     }
    
    
//     @discardableResult func getById(objectid id: String, cache: Bool?) -> Entity? {
//         let query = PFQuery(className: "Event")
//         var result:Entity?
//         query.getObjectInBackground( withId: id, block: { (object, error) in
//             if error == nil {
//                 result = object // you have to pass this to the exterior or you get a Unexpected non-void return value in void function
//             }
//             else {
//                 print("Error: \(error!)")
//             }
//             })
//         return result
//     }
    
    
//     @discardableResult func getByLocation(location: PFGeoPoint, cache: Bool?) -> [Entity]? {
//         let query = PFQuery(className: "Event")
//         var results = [Entity]()
//         query.findObjectsInBackground(block: { (objects, error) in
//             if error == nil {
//                 results = objects // todo: Implemetn comparator in Parse to sort by location
//             }
//             else {
//                 print("Error: \(error!)")
//             }
//         })
//         if (!results.isEmpty){
//             return results
//         }
//     }
    
//     @discardableResult func getByLatLon(lat: Double, lon: Double, cache: Bool?) -> [Entity] {
        
//     }
//     func getByCLLocation(){
        
//     }//stub
    
//     //Create Update Delete
//     func updateById(id: Int) -> Bool {
        
//     }
    
//     func create(object: Entity) -> Bool {
        
//     }
    
//     func deleteById(id: Int) -> Bool {
        
//     }
// }


