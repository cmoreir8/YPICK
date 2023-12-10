
//  ContentView.swift
//  YPick
//
//  Created by Chris Moreira on 10/7/23.
//

import SwiftUI
import SwiftUI
import CoreData
import SwiftData
import CoreLocation
import MapKit


import SwiftUI

struct ContentView: View {
    @State private var isPopoverPresented = false // Control popover presentation
    @State private var locationChoice: Int = 0 // 0 for current location, 1 for manual entry
    @State private var locationString: String = ""
    @State private var searchResults: [String] = [] // Adjust 'Item' to match your data model

    // Create an instance of ViewController
    let viewController = ViewController()

    var body: some View {
        VStack {
            Text("YPick!")

            // Button to show the location choice popover
            Button("Choose Location") {
                isPopoverPresented.toggle() // Toggle the popover presentation
            }
            .popover(isPresented: $isPopoverPresented, arrowEdge: .bottom) {
                // Content of the popover dialog
                VStack {
                    Picker("Choose Location", selection: $locationChoice) {
                        Text("Use Current Location").tag(0)
                        Text("Enter Location Manually").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    // Show text field for manual entry if selected
                    if locationChoice == 1 {
                        TextField("Enter Location", text: $locationString)
                    }

                    Button("Proceed") {
                        // Handle the user's choice and location here
                        if locationChoice == 0 {
                            // Use current location
                            if let userLocation = viewController.userLocation {
                                viewController.performSearchWithUserLocation(userLocation)
                            } else {
                                // Handle the case where userLocation is nil (e.g., location not available)
                            }
                        } else {
                            // Use manually entered location
                            if !locationString.isEmpty {
                                // Perform a search for items using 'locationString'
                                searchForItems(locationString: locationString)
                            }
                        }

                        isPopoverPresented.toggle() // Close the popover after the action
                    }
                }
                .padding()
            }

            // Display search results if available
            if !searchResults.isEmpty {
                // Display the search results here
                // For example, a list of items based on searchResults
            }
        }
    }

    private func searchForItems(locationString: String) {
        // Call the getCoordinatesFromLocationString function from viewController
        viewController.getCoordinatesFromLocationString(locationString: locationString) { coordinates in
            if let coordinates = coordinates {
                // Coordinates are available, perform your search with coordinates
                // Use the coordinates for your search logic
                // For example:
                _ = coordinates.latitude
                _ = coordinates.longitude
                
                // Perform your search using latitude and longitude
                // ...
            } else {
                // Handle the case where geocoding failed
                // You might want to show an error message to the user
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
