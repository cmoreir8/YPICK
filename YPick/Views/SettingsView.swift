
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


struct SettingsView: View {
    @State private var isShowingLocationSettings = false
    @State private var selectedValue = 2
    @State private var selectedFoodValue = 0
    @State private var selectedPriceValue = 0
    @State private var selectedWheelValue = 0.0
    @State private var selectedWheelType: String = "Whacky"
    @State private var selectedType: String = "food"
    @State private var selectedPrice: String = ""
    @State private var selectedFoodType: String = ""
    let foodTypeData = ["", "Indian", "Mexican", "Italian", "Japanese", "Chinese", "American", "Thai", "Mediterranean", "Vegetarian", "Vegan"]
    let priceTypeData = ["", "high dollar", "cheap"]
    let wheelTypeData = ["Whacky", "Regular"]
    let items = ["Location Settings", "Type of Resturant", "Price Range"]
    let numItemsData = Array(2...10)
    let viewController = ViewController()
    @State  var latitude: Double = 0.0
    @State  var longitude: Double = 0.0
    @State private var isPresentingWheelView = false
    @EnvironmentObject var locationData: LocationData
    @State var searchResults: [String] = []
    @State var searchCoordinates: [CLLocationCoordinate2D] = []
    @State private var isLoading = false
    @State private var locationChoice: Int = 0
    @State private var isShowingInfo = false
    @State private var isShowingProfile = false
    @State private var setLocation  = false
    @State private var locationAlert  = false
    @State private var foodTypeSheet = false
    @State private var priceTypeSheet = false
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section(header: Text("Search Settings")){
                        List(items, id: \.self) { item in
                            if item == "Location Settings" {
                                Button(action: {
                                    isShowingLocationSettings = true
                                    setLocation = true
                                }) {
                                    Text(item)
                                        .foregroundColor(.black)
                                }
                            }
                            else if item == "Type of Resturant" {
                                Button(action: {
                                    foodTypeSheet.toggle()
                                }) {
                                    Text(item)
                                        .foregroundColor(.black)
                                }
                            }
                            else if item == "Price Range" {
                                Button(action: {
                                    priceTypeSheet.toggle()
                                }) {
                                    Text(item)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            
                            else {
                                NavigationLink(destination: EmptyView()) {
                                    Text(item)
                                }
                            }
                        }
                        .onChange(of: selectedFoodValue) { newValue in
                            selectedType = priceTypeData[selectedPriceValue] + " " + foodTypeData[newValue] + " restaurant"
                            print(selectedType)
                        }
                    }
                    
                    Section(header: Text("Number of Items on the Wheel")){
                     
                                NumberOfItemsView(selectedValue: $selectedValue)
                        
                    }
                    
            
                   
                    
            
                        Section(header: Text("Type of Wheel")){
                            WheelCategoryView(selectedValue: $selectedWheelValue)
                      
                        }
                    
                    .onChange(of: selectedWheelValue) { newValue in
                        selectedWheelType = wheelTypeData[Int(newValue)]
                        print(selectedWheelType)
                    }
                }
                
                Button(action: {
                    if setLocation == true{
                        isLoading = true
                        
                        
                        //print(locationData.latitude)
                        viewController.searchForFood(foodType: selectedType, latitude: locationData.latitude, longitude: locationData.longitude){ results in
                            /*       for result in results{
                             //  print("This is sent to search:",locationData.longitude)
                             // print("This is sent to search:",locationData.latitude)
                             //  print(result)
                             let limitedResults = results.prefix(11)
                             searchResults = Array(limitedResults)
                             
                             }*/
                            isLoading = false
                            
                            print("This is sent to search:",locationData.longitude)
                            print("This is sent to search:",locationData.latitude)
                            searchResults = Array(results.prefix(selectedValue).map { $0.name })
                            searchCoordinates = Array(results.prefix(selectedValue).map { $0.coordinate })
                            isPresentingWheelView = true
                        }
                    }
                        else{
                            locationAlert.toggle()
                        }
                    
                    
                }) {
                    Text("Create Wheel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Capsule().fill(Color.indigo))
                }
                .opacity(0.75)
            }
        }
        .navigationBarTitle("New Wheel Settings")
        .navigationBarTitleDisplayMode(.inline)
        .font(.subheadline)
        .fullScreenCover(isPresented: $isLoading) {
                   // Show loading screen or activity indicator as a full screen cover
                   LoadingView()
               }
        .sheet(isPresented: $isShowingLocationSettings) {
            LocationSettingsView(isSheetPresented: $isShowingLocationSettings,
                                 latitude: $latitude,
                                 longitude: $longitude
            )
           // .presentationDetents([.large,.medium,.fraction(0.25)])
        }
        
        .sheet(isPresented: $priceTypeSheet){
            PriceCategoryView(selectedValue: $selectedPriceValue)
        }
        
        .sheet(isPresented: $foodTypeSheet){
            FoodCategoryView(selectedValue: $selectedFoodValue)
        }
        
        .alert(isPresented: $locationAlert) {
            Alert(title: Text("Alert"), message: Text("Please set a location"), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $isPresentingWheelView) {
            
            if selectedWheelType == "Regular"{
                RegularWheelView(searchResults: $searchResults)
                
            }
            else{
                NavigationView
                {
                    AltWheelView(
                        searchResults: $searchResults,
                        searchCoordinates: $searchCoordinates,
                        winnerCoordinates: CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude),
                        userCoordinates: CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }
            
           }
        
        .sheet(isPresented: $isShowingProfile) {
                                // Present the InfoView as a sheet
                                ProfileView()
                            }
        .sheet(isPresented: $isShowingInfo) {
                                // Present the InfoView as a sheet
                                InfoView()
                            }
        
        .toolbar {
            
            ToolbarItemGroup {
                Button(action: {
                    isShowingProfile = true
                    
                }, label: {
                    Image(systemName: "person.circle")
                })
            }
            
            
            ToolbarItemGroup {
                Button(action: {
                    isShowingInfo = true
                    
                }, label: {
                    Image(systemName: "info.circle")
                })
            }
      
        /*
          ToolbarItemGroup {
            Button(action: {
                isLoading = true
              
                
                //print(locationData.latitude)
                viewController.searchForFood(foodType: selectedType, latitude: locationData.latitude, longitude: locationData.longitude){ results in
              /*       for result in results{
                       //  print("This is sent to search:",locationData.longitude)
                        // print("This is sent to search:",locationData.latitude)
                       //  print(result)
                         let limitedResults = results.prefix(11)
                         searchResults = Array(limitedResults)
                         
                     }*/
                    isLoading = false
                    
                    print("This is sent to search:",locationData.longitude)
                     print("This is sent to search:",locationData.latitude)
                    searchResults = Array(results.prefix(selectedValue).map { $0.name })
                    searchCoordinates = Array(results.prefix(selectedValue).map { $0.coordinate })
                    isPresentingWheelView = true
                    print(selectedValue)
                 }
                
            }, label: {
              Text("Spin")
              Image(systemName: "chevron.right")
            })
           /*
            .background(
                NavigationLink("", destination: AltWheelView(searchResults: $searchResults, searchCoordinates: $searchCoordinates, winnerCoordinates: CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude), userCoordinates: CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)), isActive: $isPresentingWheelView))
            .navigationBarBackButtonHidden(true)
            
            */
              
          }
        */
          
        }
 
    }
    
}

/*
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
*/
