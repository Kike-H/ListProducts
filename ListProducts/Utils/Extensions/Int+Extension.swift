//
//  Int+Extension.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation

extension Int {
    func formattedPrice() -> String {
        String(format: "%.2f", Double(self))
    }
}
