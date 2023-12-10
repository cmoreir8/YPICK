//
//  WheelView.swift
//  YPick
//
//  Created by Chris Moreira on 10/23/23.
//

import SwiftUI
import Foundation
import SpriteKit

class GameScene: SKScene {
    var wheel: SKSpriteNode!
    var arrow: SKSpriteNode!
    var isRotating: Bool = false
    let rotationDuration: TimeInterval = 3.0 // Adjust the duration as needed

    override func sceneDidLoad() {
        addWheel()
        addArrow()
        addCirclesToEdgeOfWheel()
    }

    func addWheel() {
        wheel = SKSpriteNode(imageNamed: "wheel_1")
        wheel.xScale = 0.2
        wheel.yScale = 0.2
        wheel.position = CGPoint(x: size.width * 0.8, y: size.height * 0.8)
        self.addChild(wheel)
    }

    func addArrow() {
        arrow = SKSpriteNode(imageNamed: "arrow_1_inPixio")
        arrow.xScale = 1.5
        arrow.yScale = 2.0
        arrow.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        arrow.zRotation = CGFloat(65).degreesToRadians()
        self.addChild(arrow)
    }

    func addCirclesToEdgeOfWheel() {
        let numCircles = 14  // Adjust the number of circles as needed
        let radius: CGFloat = wheel.size.width * 0.47  // Assuming the wheel's width is the diameter

        for i in 0..<numCircles {
            let angle = CGFloat(i) * (CGFloat.pi * 2) / CGFloat(numCircles)
            let circle = SKSpriteNode(imageNamed: "peg")  // Replace with your circle image name
            circle.xScale = 0.025  // Adjust the scale as needed
            circle.yScale = 0.025  // Adjust the scale as needed

            let x = wheel.position.x + radius * cos(angle)
            let y = wheel.position.y + radius * sin(angle)

            circle.position = CGPoint(x: x + 195, y: y + 425)
            self.addChild(circle)
        }
    }

    func spinWheel(byAngle angle: CGFloat) {
        if !isRotating {
            isRotating = true
            let rotateAction = SKAction.rotate(byAngle: angle, duration: rotationDuration)
            wheel.run(rotateAction) {
                self.isRotating = false
            }
        }
    }
    
    
    func createBackground() {
           let backgroundNode = SKSpriteNode(color: .systemBlue, size: self.size)
           backgroundNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
           backgroundNode.zPosition = -1 // Place it behind other nodes

           self.addChild(backgroundNode)
       }
    
    override func didChangeSize(_ oldSize: CGSize) {
            if size != .zero
            {
            createBackground()
              guard wheel != nil, wheel != nil else { return }
              wheel.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
              arrow.position = CGPoint(x: size.width*0.7, y: size.height*0.8)
            }
          }
        
    
    
}

struct WheelView: View {
    @StateObject var gameScene: GameSceneController = GameSceneController()

    var body: some View {
       
            
            VStack {
                SpriteView(scene: gameScene.scene)
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let rotationSensitivity: CGFloat = 0.01
                                let rotationAngle = -value.translation.width * rotationSensitivity
                                gameScene.spinWheel(byAngle: rotationAngle)
                            }
                    )
        }
    }
        
}

class GameSceneController: ObservableObject {
    var scene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }

    func spinWheel(byAngle angle: CGFloat) {
        if let gameScene = scene as? GameScene {
            gameScene.spinWheel(byAngle: angle)
        }
    }
}

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180
    }
}

#Preview {
    WheelView()
}
