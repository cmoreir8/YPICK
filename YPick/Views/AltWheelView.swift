//
//  AltWheelView.swift
//  YPick
//
//  Created by Chris Moreira on 10/29/23.
//

import SwiftUI
import Foundation
import SpriteKit
import MapKit

struct CircleView: View {
    let centerX: CGFloat
    let centerY: CGFloat
    let radius: CGFloat
   

    var body: some View {
        Ellipse()
            .frame(width: radius , height: radius )
            .position(x: centerX, y: centerY)
    }
}
struct OffsetResult {
    var result: String
    var xOffset: CGFloat
    var yOffset: CGFloat
    var rotation: Double
    var textX : CGFloat
    var textY: CGFloat
    var coordinates: CLLocationCoordinate2D
}


struct AltWheelView: View {
    @Binding var searchResults: [String]
    @Binding var searchCoordinates: [CLLocationCoordinate2D]
    @State var offsetResults: [OffsetResult] = []
    @State private var winnerResult: String?
    @State var winnerCoordinates: CLLocationCoordinate2D
    @State var userCoordinates: CLLocationCoordinate2D
    @State private var isWinnerPagePresented = false
    let colors = (0...10).map { _ in Color.random() }
    @State var rotation = 0.0
    @State  var arrowTipPosition: CGPoint?
    @State private var selectedSlice: Int?
    @State var textPositions: [CGPoint] = []
    @Environment(\.presentationMode) var presentationMode
    
    private var anglePerSlice: Double {
        360.0 / Double(searchResults.count)
    }

    func offsetDegree(index: Int) -> Double {
        (Double(index) * anglePerSlice + anglePerSlice / 2 + rotation).degreesToRadians
    }

    var body: some View {
       
        VStack {
            ZStack {
                ForEach(searchResults.indices, id: \.self) { index in
                    if index < searchResults.count{
                        let result = searchResults[index]
                        let xOffset = cos(offsetDegree(index: index)) * 85
                        let yOffset = sin(offsetDegree(index: index)) * 85
                        let textX = 180 + xOffset
                        let textY = 345 + yOffset
                        let coordinates = searchCoordinates[index]
                        
                       
                        
                        SliceView(result: result, index: index, angle: anglePerSlice, rotation: rotation)
                            .fill(colors[index])
                        SliceBorder(index: index, angle: anglePerSlice)
                            .stroke(Color.black, lineWidth: 3)
                            .rotationEffect(.degrees(rotation))
                        
                        Text(result)
                            .font(result.count > 20 ? .system(size: 8) : .system(size: 14))
                            .rotationEffect(.degrees(Double(index) * anglePerSlice + anglePerSlice / 2 + rotation))
                            .offset(x: cos(offsetDegree(index: index)) * 85,
                                    y: sin(offsetDegree(index: index)) * 85)
                            .onAppear {
                                let offsetResult = OffsetResult(result: result, xOffset: xOffset, yOffset: yOffset, rotation: Double(index) * anglePerSlice + anglePerSlice / 2 + rotation, textX: textX, textY: textY, coordinates: coordinates)
                                    offsetResults.append(offsetResult)
                                   // print(offsetResults)
                                }

                    }
                }
                GeometryReader { geometry in
                        Image("arrow_1_inPixio")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 225, height: 200) // Adjust the size as needed
                            .rotationEffect(.degrees(-50), anchor: .center) // Rotate the image around its center
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the image
                          /*  .onAppear {
                                    let arrowTipPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2 - 235)
                                    print("Arrow Tip Position: \(arrowTipPosition)")
                                    self.arrowTipPosition = arrowTipPosition
                                    
                                }*/
                    }
               
                    .offset(x:90, y: -235)
                /*
                    CircleView(centerX: 225, centerY: 180, radius: 10)
                            .foregroundColor(.blue)
                    CircleView(centerX: 180, centerY: 345, radius: 10)
                            .foregroundColor(.red)
                    CircleView(centerX: 180+81.56, centerY: 345+23.95, radius: 10)
                            .foregroundColor(.red)
               
                    Text("test")
                        .rotationEffect(.degrees(8 * anglePerSlice + anglePerSlice / 2 + rotation))
                        .offset(x: cos(offsetDegree(index: 8)) * 85, y: sin(offsetDegree(index: 8)) * 85)
                     
                SquareView()
                       .fill(Color.yellow)
                       .rotationEffect(.degrees(75))
                       .frame(width: 100, height: 100)
                       .offset(x:0, y:280)
                
                SquareView()
                       .fill(Color.blue)
                       .rotationEffect(.degrees(90))
                       .frame(width: 100, height: 100)
                       .offset(x:0, y:280)
                
                */
                Image("christmasback4")
                    .resizable()
                    .scaledToFit()
                    .offset(x:30, y:300)
                
                Image("christmasback5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .offset(x:-110, y:-350)
                    .rotationEffect(.degrees(7))
                  
                   Text("TAP WHEEL TO SPIN")
                       .foregroundColor(.black)
                       .font(.headline)
                       .offset(x: -5, y: 280)
                    /*   .animation(
                               Animation.easeInOut(duration: 1.0)
                                   .repeatForever(autoreverses: true)
                           )*/
            }
            .onTapGesture {
                let randomAmount = Double(Int.random(in: 700..<1500))
                rotation += randomAmount
                let targetX = 225
                let targetY = 180
                // Initialize variables to keep track of the closest OffsetResult and its distance
                var closestOffsetResult: OffsetResult? = nil
                var closestDistance = Double.infinity
                
                
                offsetResults.removeAll() // Clear existing results
                    // Recalculate and update offsetResults based on the new rotation
                    for (index, result) in searchResults.enumerated() {
                        let xOffset = cos(offsetDegree(index: index)) * 85
                        let yOffset = sin(offsetDegree(index: index)) * 85
                        let textX = 180 + xOffset
                        let textY = 345 + yOffset
                        let coordinates = searchCoordinates[index]
                        
                        let offsetResult = OffsetResult(result: result, xOffset: xOffset, yOffset: yOffset, rotation: Double(index) * anglePerSlice + anglePerSlice / 2 + rotation, textX: textX, textY: textY, coordinates: coordinates )
                        offsetResults.append(offsetResult)
                        
                        let distance = sqrt(Double((textX - 225) * (textX - 225) + (textY - 180) * (textY - 180)))

                            // Check if this OffsetResult is closer than the current closest one
                            if distance < closestDistance {
                                closestDistance = distance
                                closestOffsetResult = offsetResult
                            }
                    }
                
              //  print("\(offsetResults)\n")
                if let closest = closestOffsetResult {
              //      print("The closest OffsetResult to (\(targetX), \(targetY)) //is: \(closest.result)")
                    winnerResult = closest.result
                    winnerCoordinates = closest.coordinates
                } else {
                    print("No OffsetResults were provided.")
                }

            }
            .animation(.easeInOut(duration: 1.5), value: rotation)
        }
        
        .padding()
        
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        
            // Add a button to the toolbar
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isWinnerPagePresented.toggle()
    
                }, label: {
                    Text("Winner Details")
                        .foregroundColor(.white)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                  })
                .sheet(isPresented: $isWinnerPagePresented) {
                    WinnerPageView(isWinnerPagePresented: $isWinnerPagePresented, winnerResult: winnerResult ?? "", winnerCoordinates: winnerCoordinates, userCoordinates: userCoordinates)
                        .presentationDetents([.large,.medium,.fraction(0.5)])
                            }
            }
            
            
        }
        .background(backgroundGradientForTimeOfDay())
        
                
    }
      
    func backgroundGradientForTimeOfDay() -> some View {
            let currentHour = Calendar.current.component(.hour, from: Date())

            let gradientStops: Gradient = {
                switch currentHour {
                case 6..<18: // Daytime
                    return Gradient(colors: [.blue, .cyan])
                default: // Nighttime
                    return Gradient(colors: [.indigo, .black])
                }
            }()

            return LinearGradient(gradient: gradientStops, startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
        }
    
}

struct BackButton: View {
    var dismissAction: () -> Void

    var body: some View {
        Button(action: {
            dismissAction()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Back")
                    .foregroundColor(.white)
            }
        }
    }
}

struct SliceView: Shape {
    var result: String
    var index: Int
    var angle: Double
    var rotation: Double
    
    let radius: CGFloat = 85
    let textOffset: CGFloat = 20
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle = Double(index) * angle
        let endAngle = angle + Double(index) * angle
        var path = Path()
        
        path.move(to: center)
        path.addArc(center: center,
                    radius: rect.width / 2,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false)
        
        path.closeSubpath()
        return path.rotation(.degrees(rotation)).path(in: rect)
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    
}

extension Double {
    func radiansToDegrees() -> Double {
        return self * 180.0 / .pi
    }
}

struct SliceBorder: Shape {
    var index: Int
    var angle: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle = Double(index) * angle
        let endAngle = angle + Double(index) * angle
        var path = Path()
        path.move(to: center)
        path.addArc(center: center,
                    radius: rect.width / 2,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false)
        
        path.closeSubpath()

        return path
    }
}

extension Double {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension Color {
    static func random() -> Color {
        let red = Double.random(in: 0.7...1)
        let green = Double.random(in: 0.7...1)
        let blue = Double.random(in: 0.7...1)
        return Color(red: red, green: green, blue: blue)
    }
}




struct AltWheelView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
            CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
            // Add more dummy coordinates as needed
        ]

        return AltWheelView(searchResults: .constant(["Result 1", "Result 2", "Result 3"]),
                            searchCoordinates: .constant(dummyCoordinates), winnerCoordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), userCoordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
    }
}


struct SquareView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        return path
    }
}
