//
//  PriceCategoryView.swift
//  YPick
//
//  Created by Chris Moreira on 12/1/23.
//

import SwiftUI

struct PriceCategoryView: View {
    @Binding var selectedValue: Int
    let data = ["", "high dollar", "cheap"]

    var body: some View {
        List {
            ForEach(data.indices, id: \.self) { index in
                NavigationLink(destination: Text("Selected: \(data[index])")) {
                    HStack {
                        Text(data[index])
                        Spacer()
                        if selectedValue == index {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .onTapGesture {
                    selectedValue = index
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
