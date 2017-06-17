//
//  MakeEventViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 5/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//



import UIKit
import MapKit
import UIKit
import CoreLocation

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    let manager = CLLocationManager()
    
    @IBOutlet var Caption: UILabel!

    @IBOutlet weak var eventslisting: UITableView!
    @IBOutlet weak var eventsmap: MKMapView!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.startUpdatingLocation()
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(2.5,2.5)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        eventsmap.setRegion(region,animated: true)
        
        self.eventsmap.showsUserLocation = true
        
        manager.stopUpdatingLocation()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var i = 0
        
        for coordinate in locations {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.subtitle = captions[i]
            annotation.title = titles[i]
            
            self.eventsmap.addAnnotation(annotation)
            
            i = i + 1
            
            
            
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        eventslisting.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCell
        
        cell.name.text = titles[indexPath.row]
        
        cell.caption.text = captions[indexPath.row]
        
        cell.date.text = times[indexPath.row]
        
        return cell
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.eventsmap.annotations.count != 0{
            annotation = self.eventsmap.annotations[0]
            self.eventsmap.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found",preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //3
            self.pointAnnotation = MKPointAnnotation()
            //self.pointAnnotation.subtitle = self.captionname.text
            //self.pointAnnotation.title = self.eventname.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:
                localSearchResponse!.boundingRegion.center.longitude)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(self.pointAnnotation.coordinate, span)
            self.eventsmap.setRegion(region, animated: true)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.eventsmap.centerCoordinate = self.pointAnnotation.coordinate
            self.eventsmap.addAnnotation(self.pinAnnotationView.annotation!)
            
        }
    }

    
    
    
}
