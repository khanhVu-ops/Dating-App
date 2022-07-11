//
//  Extentions+UIView.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import Foundation
import  UIKit

extension UIView {
    func animateBorderWidth(toValue: CGFloat, duration: Double = 0.3) {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = layer.borderWidth
        animation.toValue = toValue
        animation.duration = duration
        layer.add(animation, forKey: "Width")
        layer.borderWidth = toValue
      }
}
//extension UITextView {
//    func adjustUITextViewHeight() {
//        self.translatesAutoresizingMaskIntoConstraints = true
//        self.sizeToFit()
//        self.isScrollEnabled = false
//    }
//}
