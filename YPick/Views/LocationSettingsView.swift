import SwiftUI
import CoreLocation
import MapKit

struct LocationSettingsView: View {
    @Binding var isSheetPresented: Bool // Binding to control sheet presentation
    @State private var locationChoice: Int = 0 // 0 for current location, 1 for manual entry
    @State private var locationString: String = ""
    @State private var searchResults: [String] = []
    @State private var showAlert = false
    @State private var locationPermissionGranted = false
    @State private var userLocation: CLLocation?
    @Binding var latitude: Double
    @Binding var longitude: Double 
    @EnvironmentObject var locationData: LocationData
    @State private var updateLocationData = false
    // Create an instance of ViewController
    let viewController = ViewController()
  //  let locationManager = LocationManager.shared
    @StateObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
 

    var body: some View {
        
        VStack {
            // Content of the popover dialog
            VStack {
                Picker("Choose Location", selection: $locationChoice) {
                    Text("Use Current Location").tag(0)
                    Text("Enter Location Manually").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                // Show text field for manual entry if selected
                if locationChoice == 1 {
                    VStack{
                        
                         
                            TextField("Enter Location", text: $locationString)
                        
                        .multilineTextAlignment(.center)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    Map(coordinateRegion: .constant(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: locationData.latitude,
                                longitude: locationData.longitude
                            ),
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    ))
                    .cornerRadius(10)
                    .padding()
                }
                if locationChoice == 0 {
                    Map(coordinateRegion: .constant(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: locationData.latitude,
                                longitude: locationData.longitude
                            ),
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    ))
                    .cornerRadius(10)
                    .padding()
                }
                Spacer()
                Button("Enter") {
                    // Handle the user's choice and location here
                if locationChoice == 0 {
                        saveChanges()
                        
                    } 
                else {
                        // Use manually entered location
                        if !locationString.isEmpty {
                            getManualLocation(locationString: locationString)
                            
                        }
                        isSheetPresented = false
                    }
                }
                .frame(maxWidth: 150, maxHeight: 50)
                .foregroundColor(.white)
                .background(Capsule().fill(Color.yellow)
                    .onTapGesture {
                        if locationChoice == 0 {
                                saveChanges()
                                
                            }
                        else {
                                // Use manually entered location
                                if !locationString.isEmpty {
                                    getManualLocation(locationString: locationString)
                                    
                                }
                                isSheetPresented = false
                            }
                    })
                
            }
            .padding()
            // Map displaying the current location
             
        }
        .onAppear{
         //   print("latitude: \(userLatitude)")
          //   print("longitude: \(userLongitude)")
            if let userLatDouble = Double(userLatitude), let userLongDouble = Double(userLongitude) {
                                    locationData.latitude = userLatDouble
                                    locationData.longitude = userLongDouble
                                }
        }
    }

    func getManualLocation(locationString: String) {
        // Call the getCoordinatesFromLocationString function from viewController
        viewController.getCoordinatesFromLocationString(locationString: locationString) { coordinates in
            if let coordinates = coordinates {
                self.latitude = coordinates.latitude
                self.longitude = coordinates.longitude
                locationData.latitude = self.latitude
                locationData.longitude = self.longitude
                
            } else {
                print("failed")
            }
        }
    }

    private func saveChanges() {
            isSheetPresented.toggle() // Close the sheet
        }
    }

class LocationData: ObservableObject {
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    var coordinate: CLLocationCoordinate2D {
           CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
}
