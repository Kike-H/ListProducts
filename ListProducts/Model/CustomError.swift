//
//  CustomError.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation
import Foundation

enum CustomError: Error {
    case decoding(mensaje: String)
    
    var msg: String {
        switch self {
        case .decoding(let mensaje):
            return mensaje
        }
    }
}
