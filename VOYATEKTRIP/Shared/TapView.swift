//
//  TapView.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//


import UIKit

class TapView: UIView {
    private var tapAction: (() -> Void)?

    // Method to set up the tap action with a closure
    func addTap(action: @escaping () -> Void) {
        self.tapAction = action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // Make sure the view can be tapped
    }

    // Method that handles the tap and triggers the closure
    @objc private func handleTapGesture() {
        tapAction?()
    }
}
