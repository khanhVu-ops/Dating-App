////
////  DialogHelper.swift
////  Habiibi
////
////  Created by KhanhVu on 7/18/22.
////
//
//import Foundation
//import RxCocoa
//import RxSwift
//import SVProgressHUD
////import SwiftEntryKit
//import UIKit
//
//class DialogHelper {
//    static let shared = DialogHelper()
//
//    func showPopup(title: String?, msg: String) {
//        let alert = UIAlertController(title: title ?? "", message: msg, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
//            _ in
//            UIApplication.getTopViewController()?.LoadingStop()
//        }))
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            UIApplication.getTopViewController()?.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func hideHUD() {
//        SVProgressHUD.popActivity()
//    }
//
//    func showHUD() {
//        SVProgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.show()
//    }
//}
//
//extension UIApplication {
//    class func getTopViewController() -> UIViewController? {
//        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
//
//        if var topController = keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//
//            // topController should now be your topmost view controller
//            return topController
//        }
//        return nil
//    }
//}
