//
//  CellProduct.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import SwiftUI

struct CellProduct: View {
    var product: Product

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Imagen del producto
            AsyncImage(url: URL(string: product.galleryImagesVariants?.first ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80) // Tamaño de la imagen
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Esquinas redondeadas
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            // Información del producto
            VStack(alignment: .leading, spacing: 8) {
                // Nombre del producto
                Text(product.productDisplayName ?? "Producto desconocido")
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)

                // Precio original (tachado y gris)
                if let listPrice = product.listPrice {
                    Text("$\(listPrice.formattedPrice())")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .strikethrough()
                }

                // Precio promocional (en rojo y bold)
                if let promoPrice = product.promoPrice {
                    Text("$\(promoPrice.formattedPrice())")
                        .font(.headline)
                        .foregroundColor(.red)
                }

                // Scroll horizontal para los colores
                if let variantsColor = product.variantsColor, !variantsColor.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(variantsColor) { colorVariant in
                                Circle()
                                    .fill(Color(hex: colorVariant.colorHex ?? "#000000"))
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                Color(hex: colorVariant.colorHex ?? "#000000") == .black ? .white : .black,
                                                lineWidth: 0.5
                                            )
                                    )
                            }
                        }
                    }
                }
            }
        }
        .padding(8)
    }
}


