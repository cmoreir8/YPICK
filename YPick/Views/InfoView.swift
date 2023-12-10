//
//  InfoView.swift
//  YPick
//
//  Created by Chris Moreira on 11/30/23.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Location Settings")) {
                    Text("The app works best when you enable location when using app. The app can work without your current location, you simply have to enter your location. You can change the location to search at any time pressing location setting button")
                }

                Section(header: Text("Number of Wheel Items")) {
                    Text("You can choose the number of resturants to put on the wheel 2-10, simply but swiping up or down on the dial.")
                }

                Section(header: Text("Type of Food")) {
                    Text("There are serveral types of resturants you can search and you once again can choose by simply moving the dial up or down.")
                }

                Section(header: Text("Wheel Type")) {
                    Text("You can choose the regualar wheel or the whacky wheel by turning the dial.")
                }

                Section(header: Text("Price")) {
                    Text("You choose the price of the resturant; any, low, medium, or high.")
                }
                
                Section(header: Text("Create Wheel")) {
                    Text("Once you press the Create Wheel button the app navigates you to a wheel that is created from your selections")
                }
                
                Section(header: Text("Winner Details")) {
                    Text("Once you spin and land on a resturant you can view more details about the winner by pressing the Winner Details button. This opens a page that has the winner and also two buttons, one that is a star which shows yelp information about the resturant and a map that gives you the direction to the resturant if you have your location enabled.")
                }

                Section(header: Text("About Author")) {
                    Text("Christopher Moreira wrote this app! Here is a picture of him.")
                    Image("author")
                        .resizable()
                        .scaledToFit()
                }
            }
            .navigationBarTitle("Information")
        }
    }
}

#Preview {
    InfoView()
}
