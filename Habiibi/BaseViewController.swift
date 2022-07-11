//
//  ViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.init(hexString: "#FFA8B5"),
            UIColor.init(hexString: "#FFCCCB")
        ]
        gradient.locations = [0.5,0.25]
        return gradient
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        gradient.frame = view.bounds
//        view.layer.addSublayer(gradient)
    }
    
    func setUpView() {
        
    }
    func showError(lbError: UILabel, enable: Bool, text: String) {
        lbError.isHidden = !enable
        lbError.text = text
    }
    func updateButtonUI(_ btn: UIButton, enable: Bool, color: UIColor) {
        btn.isEnabled = enable
        btn.backgroundColor = enable ? color : color.withAlphaComponent(0.3)
    }
}

