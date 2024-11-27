//
//  String+Extension.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation

extension Double {
    func formattedPrice() -> String {
        String(format: "%.2f", self)
    }
}
