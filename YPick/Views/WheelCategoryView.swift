//
//  WheelCategoryView.swift
//  YPick
//
//  Created by Chris Moreira on 12/2/23.
//

import SwiftUI

struct WheelCategoryView: View {
    @Binding var selectedValue: Double
    let minValue: Double = 0
    let maxValue: Double = 1
    let step: Double = 1.0

    var body: some View {
        VStack {
            Text("Select Wheel Type")
                .font(.system(size: 12))
            Slider(value: $selectedValue, in: minValue...maxValue, step: step) {
                Text(selectedValue == 0 ? "Whacky" : "Regular")
                    .font(.system(size: 10))
            }
            .accentColor(selectedValue == 0 ? .blue : .green)
            .padding(.horizontal)
            .labelsHidden()

            HStack {
                Text("Whacky")
                    .font(.system(size: 10))
                    .foregroundColor(selectedValue == 0 ? .blue : .black)
                Spacer()
                Text("Regular")
                    .font(.system(size: 10))
                    .foregroundColor(selectedValue == 1 ? .green : .black)
            }
        }
    }
}
