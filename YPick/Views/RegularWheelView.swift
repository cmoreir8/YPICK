import SwiftUI
import Foundation
import SpriteKit
import MapKit

import SwiftUI

struct RegularWheelView: View {
    @Binding var searchResults: [String]
    @State var rotation: CGFloat = 0.0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
      
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                        Text("Back")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                }
                .offset(x:-150, y:-175)
                
                Wheel(rotation: $rotation, searchResults: $searchResults)
                    .frame(width: 300, height: 300) // Adjust the size of the wheel
                    .rotationEffect(.radians(rotation))
                    .offset(x:-100, y: 200)
                    .animation(.easeInOut(duration: 1.5), value: rotation)
                    .overlay(
                        GeometryReader { geometry in
                            Image("arrow_1_inPixio")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 225, height: 200) // Adjust the size as needed
                                .rotationEffect(.degrees(-50), anchor: .center)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                    )
                    .offset(x:90, y: -235)
                
                Button("Spin") {
                    let randomAmount = Double(Int.random(in: 7..<15))
                    rotation += randomAmount
                }
                .frame(maxWidth: 150, maxHeight: 50)
                .foregroundColor(.white)
                .background(Capsule().fill(Color.yellow).onTapGesture {
                })
                .offset(x: 0)
                
            }
            .padding()
    }
}

struct Wheel: View {
    @Binding var rotation: CGFloat
    @Binding var searchResults: [String]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(searchResults.indices, id: \.self) { index in
                    ZStack {
                        Circle()
                            .inset(by: proxy.size.width / 4)
                            .trim(from: CGFloat(index) * segmentSize, to: CGFloat(index + 1) * segmentSize)
                            .stroke(Color.all[index], style: StrokeStyle(lineWidth: proxy.size.width / 2))
                            .rotationEffect(.radians(.pi * segmentSize))
                            .opacity(0.3)
                        label(text: searchResults[index], index: CGFloat(index), offset: proxy.size.width / 4)
                    }
                }
            }
        }
    }

    var segmentSize: CGFloat {
        1 / CGFloat(searchResults.count)
    }

    func rotation(index: CGFloat) -> CGFloat {
        (.pi * (2 * segmentSize * (CGFloat(index + 1))))
    }

    func label(text: String, index: CGFloat, offset: CGFloat) -> some View {
        Text(text)
            .rotationEffect(.radians(rotation(index: CGFloat(index))))
            .font(text.count > 20 ? .system(size: 8) : .system(size: 14))
            .offset(x: cos(rotation(index: index)) * offset, y: sin(rotation(index: index)) * offset)
    }
}

extension Color {
    static var all: [Color] {
        [Color.yellow, .green, .pink, .cyan, .mint, .orange, .teal, .indigo, .blue, .pink]
    }
}

