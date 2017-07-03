//
//  MakeEventViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 5/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
var captions: Array<String> = Array()
var titles: Array<String> = Array()
var locations: Array<CLLocationCoordinate2D> = Array()
var times: Array<String> = Array()
var manager = CLLocationManager()

class MakeEventViewController: UIViewController, UISearchBarDelegate,CLLocationManagerDelegate {
    @IBOutlet var captionname: UITextField!
    @IBOutlet weak var eventname: UITextField!
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet var DatePicker: UIDatePicker!

    @IBOutlet var mapView: MKMapView!
    
    @IBAction func showSearchBar(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startUpdatingLocation()
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5,0.5)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region,animated: true)
        
        self.mapView.showsUserLocation = true
        
        manager.stopUpdatingLocation()
        
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
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
            self.pointAnnotation.subtitle = self.captionname.text
            self.pointAnnotation.title = self.eventname.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:
                localSearchResponse!.boundingRegion.center.longitude)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(self.pointAnnotation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
        }
    }
    
    @IBAction func eventcreator(_ sender: Any) {
        titles.insert(eventname.text!, at: 0)
        //locations.insert(self.pointAnnotation.coordinate, at: 0)
        locations.append(self.pointAnnotation.coordinate)
        captions.insert(self.captionname.text!, at: 0)
      
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd, YYYY"
        times.append(formatter.string(from: DatePicker.date))
        
        tabBarController?.selectedIndex = 1
        
        captionname.text = ""
        eventname.text = ""
        
        
        
    }
    
}
