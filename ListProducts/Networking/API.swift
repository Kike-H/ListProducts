//
//  API.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation
import Alamofire

enum API {
    //    MARK: - SESION
    private static let session: Session = Alamofire.Session()
    
    //    MARK: - HOST
    static var host: String = "https://shoppapp.liverpool.com.mx"
    
    //    MARK: - REQUESTS
    case getProducts(txtSearch: String, page: Int, sort: String? = nil)
    
    //    MARK: - URL
    var url: String {
        switch self {
        case .getProducts(let txtSearch, let page, let sort):
            if let sort {
                return "\(API.host)/appclienteservices/services/v8/plp/sf?page-number=\(page)&search-string=\(txtSearch)&sort-option=\(sort)&force-plp=false&number-of-items-per-page=40&cleanProductName=false"
            }
            return "\(API.host)/appclienteservices/services/v8/plp/sf?page-number=\(page)&search-string=\(txtSearch)&force-plp=false&number-of-items-per-page=40&cleanProductName=false"
        }
    }
    
    
    //    MARK: - METHOD
    var method: HTTPMethod {
        switch self {
        case .getProducts:
            return .get
        }
    }
    
    //    MARK: - HEADERS
    var heraders: HTTPHeaders {
        return ["Acept": "application/json"]
    }

    //    MARK: - PARAMETERS
    var parameters: Parameters? {
        return nil
    }
    
}


extension API {
    func execute<T: Codable>(completion: @escaping (AFResult<T>) -> Void) {
        
//        DEBUGS PRINTS
        #if DEBUG
        debugPrint("-------------------------------------------------------------------------------------------------")
        debugPrint("REQUEST")
        debugPrint("URL: \(self.url)")
        debugPrint("METHOD: \(self.method.rawValue)")
        if let parameters = self.parameters {
            debugPrint("BODY: \(parameters)")
        }
        #endif
        
        API.session.request(self.url, method: self.method, parameters: self.parameters, encoding: JSONEncoding.default, headers: self.heraders).responseData { response in
            debugPrint("-------------------------------------------------------------------------------------------------")
            debugPrint("RESPONSE")
            let statusCode = response.response?.statusCode ?? 500
            debugPrint("STATUS CODE: \(statusCode)")
            
            let defaultError: AFError = .createURLRequestFailed(error: CustomError.decoding(mensaje: "Error en la respuesta del servidor."))
            if statusCode >= 400 {
                #if DEBUG
                debugPrint("ERROR")
                #endif
                self.manageFailure(error: defaultError, response: response, completion: completion)
                debugPrint("-------------------------------------------------------------------------------------------------")
            } else {
                if let data = response.value {
                    #if DEBUG
                    debugPrint("SUCESS")
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        debugPrint(json)
                    }
                    #endif
                    self.manageSuccess(data: data, completion: completion)
                } else {
                    self.manageFailure(error: defaultError, response: response, completion: completion)
                }
                debugPrint("-------------------------------------------------------------------------------------------------")
            }
        }
    }
    
    
    private func manageSuccess<T: Codable>(data: Data, completion: @escaping (AFResult<T>) -> Void) {
        
        let defaultError: AFError = .createURLRequestFailed(error: CustomError.decoding(mensaje: "Error en la respuesta del servidor."))
        
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(object))
            }
        } catch DecodingError.keyNotFound(let key, _)  {
            debugPrint("NOT FOUND KEY: \(key.stringValue)")
            self.manageFailure(error: defaultError, completion: completion)
        }  catch DecodingError.valueNotFound(let type, _) {
            debugPrint("NOT FOUND VALUE: \(type)")
            self.manageFailure(error: defaultError, completion: completion)
        } catch DecodingError.typeMismatch(let type, let context) {
            debugPrint("DIFERENT TYPE FOUND VALUE: \(type).\(context.debugDescription)")
            self.manageFailure(error: defaultError, completion: completion)
        } catch DecodingError.dataCorrupted(_) {
            debugPrint("DATA CORRUPTED")
            self.manageFailure(error: defaultError, completion: completion)
        } catch {
            debugPrint("ERROR DECODED")
            self.manageFailure(error: defaultError, completion: completion)
        }
    }
    
    private func manageFailure<T: Codable>(error: Error, response: AFDataResponse<Data>? = nil, completion: @escaping (AFResult<T>) -> Void) {
        var errorMsg: AFError = .createURLRequestFailed(error: error)
//        if let data = response?.value, let strError = try? JSONDecoder().decode(GeneralResponse<String?>.self, from: data).replyText {
            errorMsg = .createURLRequestFailed(error: CustomError.decoding(mensaje: ""))
//        }
        completion(.failure(errorMsg))
        
    }
}
