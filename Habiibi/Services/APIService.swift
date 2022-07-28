//
//  APIService.swift
//  Habiibi
//
//  Created by KhanhVu on 6/29/22.
//

import Foundation
import Alamofire
protocol JsonInitObject: NSObject {
    init(json: [String : Any])
}

final class APIService {
    static let responseCodeKey = "code"
    static let responseMessageKey = "message"
    static let responseDataKey = "data"
    
   
//    static func requestHomeModel(user_id: Int, completionHandler: ((UserModel?, APIError?) -> Void)?) {
//        
//        guard let path = Bundle.main.path(forResource: "User_\(user_id)", ofType: "json") else {
//            return
//        }
//        let url = URL(fileURLWithPath: path)
//        
//        jsonResponseObject(url: url, method: .get, headers: [:], completionHandler: completionHandler)
//    }
//    static func requestListUsers(completionHandler: (([UserModel]?, APIError?) -> Void)?) {
//        
//        guard let path = Bundle.main.path(forResource: "ListUser", ofType: "json") else {
//            return
//        }
//        let url = URL(fileURLWithPath: path)
//        
//        jsonResponseList(url: url, method: .get, headers: [:], completionHandler: completionHandler)
//    }

    //MARK: BASE
    
    static private func jsonResponseObject<T: JsonInitObject>(url: URL, method: HTTPMethod, headers: HTTPHeaders, completionHandler: ((T?, APIError?) -> Void)?) {
        
        jsonResponse(url: url, isPublicAPI: false, method: method, headers: headers) { response, serverCode, serverMessage in
            
            switch response.result {
            case .success(let value):
                guard serverCode == 200 else {
                    completionHandler?(nil, .serverError(serverCode, serverMessage))
                    return
                }
                
                guard let responseDict = value as? [String: Any],
                      let dataDict = responseDict[responseDataKey] as? [String: Any] else {
                          completionHandler?(nil, .resposeFormatError)
                          return
                      }
                
                let obj = T(json: dataDict)
                
                completionHandler?(obj, nil)
                
            case .failure(let error):
                completionHandler?(nil, .unowned(error))
            }
        }
    }
    
    static private func jsonResponseList<T: JsonInitObject>(url: URL, method: HTTPMethod, headers: HTTPHeaders, completionHandler: (([T]?, APIError?) -> Void)?) {
        
        jsonResponse(url: url, isPublicAPI: false, method: method, headers: headers) { response, serverCode, serverMessage in
            
            switch response.result {
            case .success(let value):
                guard serverCode == 200 else {
                    completionHandler?(nil, .serverError(serverCode, serverMessage))
                    return
                }
                
                guard let responseDict = value as? [String: Any],
                      let dataDict = responseDict[responseDataKey] as? [[String: Any]] else {
                          completionHandler?(nil, .resposeFormatError)
                          return
                      }
                var listObj: [T] = []
                
                for item in dataDict {
                    let obj = T(json: item)
                    listObj.append(obj)
                }
                
                completionHandler?(listObj, nil)
                
            case .failure(let error):
                completionHandler?(nil, .unowned(error))
            }
        }
    }
    
    
    static private func jsonResponse(url: URL,
                                     isPublicAPI: Bool,
                                     method: HTTPMethod,
                                     parameters: Parameters? = nil,
                                     encoding: ParameterEncoding = JSONEncoding.default,
                                     headers: HTTPHeaders = [:],
                                     completionHandler: ((AFDataResponse<Any>, Int?, String?) -> Void)?) {
        
       
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON { response in
                
                var serverCode: Int? = nil
                var serverMessage: String? = nil
                
                switch response.result {
                case .success(let value):
                    serverCode = (value as? [String: Any])?[responseCodeKey] as? Int
                    serverMessage = (value as? [String: Any])?[responseMessageKey] as? String
                case .failure(_):
                    break
                }
                
                completionHandler?(response, serverCode, serverMessage)
            }
    }
}


extension APIService {
    enum APIError: Error {
        //        case loginFail
        //        case signUpFail
        case resposeFormatError
        case serverError(Int?, String?)
        case unowned(Error)
    }
}
