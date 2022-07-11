//
//  FilterViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import UIKit

class FilterViewController: BaseViewController {

    @IBOutlet weak var filterPickerView: UIPickerView!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var vTopGradient: Gradient!
    var homeVC: HomeScreenViewController?
    let filterViewModel = FilterViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
        // Do any additional setup after loading the view.
    }
    override func setUpView() {
        filterPickerView.delegate = self
        filterPickerView.dataSource = self
        vTopGradient.layer.cornerRadius = vTopGradient.frame.width/3
        
    }
    

    @IBAction func didTapBtnCancle(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBtnChoose(_ sender: Any) {
        
        print("From \(filterViewModel.from) to \(filterViewModel.destination)")
        
        homeVC?.homeViewModel.from = filterViewModel.from
        homeVC?.homeViewModel.destination = filterViewModel.destination
        navigationController?.popViewController(animated: true)
    }
    
}

extension FilterViewController: UIPickerViewDelegate {
    
}
extension FilterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterViewModel.listAge.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterViewModel.listAge[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        filterViewModel.from = filterViewModel.ages[row].0
        filterViewModel.destination = filterViewModel.ages[row].1
        
    }
    
}
