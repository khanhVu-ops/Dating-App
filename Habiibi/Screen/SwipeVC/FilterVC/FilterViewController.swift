//
//  FilterViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class FilterViewController: BaseViewController {
    @IBOutlet weak var vBtnFemaleBorder: UIView!
    @IBOutlet weak var vBtnFemale: UIView!
    @IBOutlet weak var vBtnMaleBorder: UIView!
    @IBOutlet weak var vBtnMale: UIView!
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var tfDestination: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let filterViewModel = FilterViewModel()
    let homeViewModel = HomeScreenViewModel()
    var homeVC: HomeScreenViewController?
    let disposeBag = DisposeBag()
    var enable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindTxtToViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let item = homeVC?.homeViewModel.filterRelay.value else {return}
        filterViewModel.item = item
        filterViewModel.updateUIComponent()
        configureBtnColor(btn: vBtnMale, enable: filterViewModel.tapMale)
        configureBtnColor(btn: vBtnFemale, enable: filterViewModel.tapFemale)
        filterViewModel.txtFrom.bind(to: tfFrom.rx.text).disposed(by: disposeBag)
        filterViewModel.txtDestination.bind(to: tfDestination.rx.text).disposed(by: disposeBag)
        
    }
    
    override func setUpView() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        vBtnFemaleBorder.layer.cornerRadius = vBtnFemaleBorder.frame.height/2
        vBtnFemaleBorder.layer.masksToBounds = true
        vBtnFemale.layer.cornerRadius  = vBtnFemale.frame.height/2
        vBtnFemale.layer.masksToBounds = true
        vBtnFemale.layer.borderColor = UIColor.white.cgColor
        vBtnFemale.layer.borderWidth = 5
        vBtnFemale.backgroundColor = .red
        
        vBtnMaleBorder.layer.cornerRadius = vBtnMaleBorder.frame.height/2
        vBtnMaleBorder.layer.masksToBounds = true
        vBtnMale.layer.cornerRadius  = vBtnMale.frame.height/2
        vBtnMale.layer.masksToBounds = true
        vBtnMale.layer.borderColor = UIColor.white.cgColor
        vBtnMale.layer.borderWidth = 5
        vBtnMale.backgroundColor = .red
        tfDestination.delegate = self
        tfFrom.delegate = self
        
    }
    func configureBtnColor(btn: UIView, enable: Bool) {
        btn.backgroundColor = enable ? .red : .white
    }
    
    func bindTxtToViewModel() {
        tfFrom.rx.text.orEmpty.bind(to: filterViewModel.txtFrom).disposed(by: disposeBag)
        tfDestination.rx.text.orEmpty.bind(to: filterViewModel.txtDestination).disposed(by: disposeBag)
    }
    
    
    
    @IBAction func didTapBtnFemale(_ sender: Any) {
        filterViewModel.tapFemale = !filterViewModel.tapFemale
        configureBtnColor(btn: vBtnFemale, enable: filterViewModel.tapFemale)
        if filterViewModel.tapFemale {
            filterViewModel.tapMale = false
            
            configureBtnColor(btn: vBtnMale, enable: filterViewModel.tapMale)
        }
    }
    
    @IBAction func didTapBtnMale(_ sender: Any) {
        filterViewModel.tapMale = !filterViewModel.tapMale
        configureBtnColor(btn: vBtnMale, enable: filterViewModel.tapMale)
        if filterViewModel.tapMale {
            filterViewModel.tapFemale = false
            configureBtnColor(btn: vBtnFemale, enable: filterViewModel.tapFemale)
        }
    }
    @IBAction func didTapBtnSave(_ sender: Any) {
        filterViewModel.getItems()
        homeVC?.homeViewModel.filterRelay.accept(filterViewModel.item)
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
