//
//  BaseViewModel.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation
import Alamofire

class BaseViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    func getAFError(error: AFError) -> String {
        switch error {
        case .createURLRequestFailed(let errorRequest):
            guard let customError = errorRequest as? CustomError else {
                return error.errorDescription ?? "Ocurrio algo inesperado"
            }
            switch customError {
            case .decoding(let mensaje):
                return mensaje
            }
        default:
            if error.localizedDescription.lowercased() == "urlsessiontask failed with error: the internet connection appears to be offline." {
                return "No fue posible conectar al servidor. Por favor valide su conexión a internet."
            } else if error.localizedDescription.lowercased() == "urlsessiontask failed with error: an ssl error has occurred and a secure connection to the server cannot be made."{
                return "No fue posible conectar al servidor. Por favor valide su conexión a internet."
            }else if error.localizedDescription.lowercased() == "urlsessiontask failed with error: the network connection was lost."{
                return "No fue posible conectar al servidor. Por favor valide su conexión a internet."
            }else{
                return error.localizedDescription
            }
        }
    }
    
}
