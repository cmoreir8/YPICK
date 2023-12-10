//
//  WinnerPageView.swift
//  YPick
//
//  Created by Chris Moreira on 11/19/23.
//

import SwiftUI
import MapKit
import Alamofire




struct WinnerPageView: View {
    @Binding var isWinnerPagePresented: Bool
    @State private var showAlert = false
    @StateObject private var viewModel = RatingViewModel()
    let userLocation = LocationData()
    var winnerResult: String
    var winnerCoordinates: CLLocationCoordinate2D
    var userCoordinates: CLLocationCoordinate2D
    let yelpApiKey = "U9IiV6fbWauWf1Ie-G9cUd93d19iuoYHy0CAVUUElovn8XwPEeps5ioDs8TIutWHjRjZI7x8oe7kAdoCMbwPcHHxDynszNncSJpMkYHyMpCHrZGgF4wzRFQXjE1cZXYx"
    
    
    var body: some View {
        NavigationView{
            VStack {
                Text("You Landed On: ")
                    .font(.title)
                    .bold()
                    .padding()
                    .offset(y:-50)
                    .foregroundColor(Color.indigo)
                Text(winnerResult)
                    .font(.system(size: 28))
                    .bold()
                    .padding()
                    .offset(y:-25)
                    .foregroundColor(Color.indigo)
                    .padding(10)
                Button(action: {
                    // Dismiss the winner page
                    isWinnerPagePresented = false
                }) {
                    Text("Spin Again")
                        .foregroundColor(.white)
                        .padding()
                        .background(Capsule().fill(Color.indigo))
                }
                .opacity(0.75)
                
                
            }
            /*    .overlay(
             ForEach(0..<40) { index in
             Image(systemName: "star.fill")
             .foregroundColor(.yellow)
             .opacity(0.25)
             .frame(width: 20, height: 20)
             .position(x: CGFloat.random(in: -120...350), y: CGFloat.random(in: -150...250))
             }
             )*/
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("Winner")
                        .font(.headline)
                        .overlay(
                            
                            Rectangle()
                                .frame(width: 1000, height: 1)
                                .foregroundColor(Color.gray)
                                .offset(y: 30) // Adjust this offset as needed
                            
                        )
                    
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        getDirections()
                        
                    }) {
                        Image(systemName: "map")
                            .foregroundColor(Color.black)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAlert = true
                        
                       
                    }) {
                        Image(systemName: "star")
                            .foregroundColor(Color.black)
                    }
                    
                }
                
                
            }
            .onAppear {
                           // Call your viewModel.search() function when the view appears
                          
                            viewModel.winnerResult = winnerResult
                            viewModel.winnerCoordinates = winnerCoordinates
                            viewModel.search()
                      
                       }
            .alert(isPresented: $showAlert) {
                guard let selectedBusiness = viewModel.businesses.first else {
                    // Handle the case where there are no businesses
                    return Alert(title: Text("No Business"), message: Text("No business information available"), dismissButton: .default(Text("OK")))
                }
                let isClosedString: String
                    if selectedBusiness.isClosed ?? false {
                        isClosedString = "No"
                    } else {
                        isClosedString = "Yes"
                    }

                let ratingStars = String(repeating: "⭐️", count: Int(selectedBusiness.rating ?? 0))
                
                return Alert(
                    title: Text("Restaurant Information"),
                    message: Text("Name: \(selectedBusiness.name ?? "")\nRating Out of 5 Stars: \(ratingStars)\nNumber of Reviews: \(selectedBusiness.reviewCount ?? 0)\nPhone Number: \(selectedBusiness.phone ?? "")\nOpen: \(isClosedString)"),
                    dismissButton: .default(Text("OK"))
                )
            }

            
        }
        
    }

   private func getDirections() {
       let userLocation =  CLLocationCoordinate2D(latitude: 40.0516343, longitude: -75.4266196)
           let restaurantLocation = winnerCoordinates

           let userPlacemark = MKPlacemark(coordinate: userLocation)
           let restaurantPlacemark = MKPlacemark(coordinate: restaurantLocation)

           let userMapItem = MKMapItem(placemark: userPlacemark)
           let restaurantMapItem = MKMapItem(placemark: restaurantPlacemark)

           let directionsRequest = MKDirections.Request()
           directionsRequest.source = userMapItem
           directionsRequest.destination = restaurantMapItem
           directionsRequest.transportType = .automobile

           MKMapItem.openMaps(with: [userMapItem, restaurantMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
       }
    
    
  
    
    
    
    
    
}


