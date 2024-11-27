//
//  CustomTextField.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    
    var placeholder: String = ""
    var imageIcon: String = ""
    var borderColor: Color = .gray
    var cornerRadius: CGFloat = 8.0
    var padding: CGFloat = 15.0
    var action: () -> Void

    
    var body: some View {
        HStack() {
            Image(systemName: imageIcon)
                .foregroundStyle(.gray)
                .padding(.horizontal, padding)
            TextField(placeholder, text: $text)
                .cornerRadius(cornerRadius, corners: .allCorners)
                .frame(height: 50.0)
                .keyboardType(.numberPad)
            Spacer()
            Rectangle()
                .fill(.blue)
                .cornerRadius(cornerRadius, corners: [.bottomRight, .topRight])
                .frame(width: 60.0, height: 50.0)
                .overlay(
                    HStack {
                        Button(action: action) {
                            Image(systemName: imageIcon)
                                .foregroundStyle(.white)
                                .padding(.horizontal, padding)
                        }
                    }
                )
            
        }.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    CustomTextField(text: .constant(""), placeholder: "Buscar productos", imageIcon: "magnifyingglass") {}
}
