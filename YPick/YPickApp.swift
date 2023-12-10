//
//  YPickApp.swift
//  YPick
//
//  Created by Chris Moreira on 10/7/23.
//

import SwiftUI
import UIKit
import Firebase

@main
struct YPickApp: App {
    @State private var isLoginViewPresented = true // Initialize as true to show the LoginView initially
    @State var viewModel = AuthViewModel()
    let locationData = LocationData()

    init(){
        FirebaseApp.configure()
        viewModel.userSession = Auth.auth().currentUser
        
        
            }
    
    
    var body: some Scene {
        WindowGroup {
          
                LoginView(isPresented: $isLoginViewPresented)
                .environmentObject(locationData)
                .environmentObject(viewModel)
        }
    }
}

