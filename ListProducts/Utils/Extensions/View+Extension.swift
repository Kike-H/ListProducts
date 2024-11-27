//
//  View+Extension.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func loader(_ isActive: Binding<Bool>) -> some View {
        self.overlay(
            Group {
                if isActive.wrappedValue {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea(edges: .all)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.blue)
                            .scaleEffect(1.5)
                    }
                }
            }
        )
    }
    
}
