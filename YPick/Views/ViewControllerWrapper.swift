//
//  ViewControllerWrapper.swift
//  YPick
//
//  Created by Chris Moreira on 10/7/23.
//

import SwiftUI

struct ViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update any properties or pass data to the view controller if needed
    }
}
