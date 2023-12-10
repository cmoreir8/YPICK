//
//  Search4Items.swift
//  YPick
//
//  Created by Chris Moreira on 10/7/23.
//
import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request location permissions
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // CLLocationManagerDelegate method to handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            // Once you have the user's location, you can use it for your search
            performSearchWithUserLocation(location)
        }
    }
    
    // Function to perform your search using the user's location
    func performSearchWithUserLocation(_ location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("User's Location - Latitude: \(latitude), Longitude: \(longitude)")
       
    }
    
    // Handle location authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Start updating location
        case .denied, .restricted:
            break
        case .notDetermined:
            break
        default:
            break
        }
    }
    
    
    // Function to convert a location string to coordinates using geocoding
    func getCoordinatesFromLocationString(locationString: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first,
               let location = placemark.location {
                completion(location.coordinate)
            } else {
                completion(nil)
            }
        }
    }

    func searchForFood(foodType: String, latitude: Double, longitude: Double, completion: @escaping ([(name: String, coordinate: CLLocationCoordinate2D)]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = foodType
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                             span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error performing search: \(error.localizedDescription)")
                completion([])
            } else {
                let searchResults: [(name: String, coordinate: CLLocationCoordinate2D)] = response?.mapItems.compactMap { item in
                    guard let name = item.name else { return nil }
                    return (name: name, coordinate: item.placemark.coordinate)
                } ?? []
                completion(searchResults)
            }
        }
    }

    
    
    
}
