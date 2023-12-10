//
//  MyView.swift
//  YPick
//
//  Created by Chris Moreira on 10/17/23.
//

import SwiftUI

struct MyView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        VStack {
            Text("location status: \(locationManager.statusString)")
            HStack {
                Text("latitude: \(userLatitude)")
                Text("longitude: \(userLongitude)")
            }
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
