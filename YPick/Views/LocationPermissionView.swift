//
//  LocationPermissionView.swift
//  YPick
//
//  Created by Chris Moreira on 10/7/23.
//

import SwiftUI
import CoreData
import SwiftData
import CoreLocation
import MapKit
import SwiftUI
import CoreLocation

class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
}

struct LocationPermissionView: View {
    @ObservedObject var locationManagerDelegate = LocationManagerDelegate()
    @State private var locationString: String = ""
    @State private var useCurrentLocation: Bool = true

    var body: some View {
        VStack {
            Text("To use this app, we need access to your location.")
            
            Toggle("Use Current Location", isOn: $useCurrentLocation)
            
            if !useCurrentLocation {
                TextField("Enter Location", text: $locationString)
            }
            
            Button("Proceed") {
                if useCurrentLocation {
                    // Perform an action using the user's current location
                    if locationManagerDelegate.authorizationStatus == .authorizedWhenInUse {
                        // User has granted permission to use current location
                        // Perform an action here with current location
                    } else {
                        // Handle the case where location permission is not granted
                    }
                } else {
                    // Perform an action using the manually entered location
                    if !locationString.isEmpty {
                        // Perform a manual location search using locationString
                        performManualLocationSearch(locationString: locationString)
                    }
                }
            }
        }
    }

    private func performManualLocationSearch(locationString: String) {
        
    }
}



