//
//  ViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/22/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

