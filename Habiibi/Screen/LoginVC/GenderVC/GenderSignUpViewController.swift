//
//  GenderSignUpViewController.swift
//  Habiibi
//
//  Created by KhanhVu on 6/23/22.
//

import UIKit
import RxSwift
import RxCocoa

class GenderSignUpViewController: BaseViewController {

    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    let disposeBag = DisposeBag()
    let genderViewModel = GenderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindBtnToViewModel()
        tapBtn()
    }
    override func setUpView() {
      
        btnContinue.layer.cornerRadius = 25
        
        btnMale.layer.cornerRadius = 30
        btnFemale.layer.cornerRadius = 30
        
        btnMale.layer.borderWidth = 3
        btnMale.layer.borderColor = UIColor.gray.cgColor
        btnFemale.layer.borderWidth = 3
        btnFemale.layer.borderColor = UIColor.gray.cgColor
        
        btnMale.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        btnMale.layer.shadowColor = UIColor.gray.cgColor
        btnMale.layer.shadowRadius = 3
        btnFemale.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        btnFemale.layer.shadowColor = UIColor.gray.cgColor
        btnFemale.layer.shadowRadius = 3
        
    }
    
    
    
    func bindBtnToViewModel() {
//        genderViewModel.isBtnContinueEnable.bind(to: btnContinue.rx.isEnabled).disposed(by: disposeBag)
        genderViewModel.isBtnContinueEnable.subscribe(onNext: { [weak self] valid in
            self?.btnContinue.isEnabled = valid
            self?.btnContinue.backgroundColor = valid ? .blue : UIColor.blue.withAlphaComponent(0.3)
        })
        .disposed(by: disposeBag)
        btnContinue.rx.tap.subscribe(onNext: { [weak self] in
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "FillNameSignUpViewController") as! FillNameSignUpViewController
            
            self?.genderViewModel.saveDataToGobalData()
           
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    func tapBtn() {
        btnMale.rx.tap.subscribe(onNext: { [weak self] in
            if self?.genderViewModel.didTapMale.value == false {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    
                    guard let self = self else {return}
                    self.btnMale.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    self.btnFemale.transform = .identity
                    self.genderViewModel.didTapMale.accept(true)
                    self.genderViewModel.didTapFemale.accept(false)
                }
            }else {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else {return}
                    self.btnMale.transform = .identity
                    self.genderViewModel.didTapMale.accept(false)
                }
            }
        })
        .disposed(by: disposeBag)
        
        btnFemale.rx.tap.subscribe(onNext: { [weak self] in
            print("Tap FeMale")
            if self?.genderViewModel.didTapFemale.value == false {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else {return}
                    self.btnFemale.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    self.btnMale.transform = .identity
                    self.genderViewModel.didTapFemale.accept(true)
                    self.genderViewModel.didTapMale.accept(false)
                }
            }else {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else {return}
                    self.btnFemale.transform = .identity
                    self.genderViewModel.didTapFemale.accept(false)
                }
            }
        })
        .disposed(by: disposeBag)
    }
}
