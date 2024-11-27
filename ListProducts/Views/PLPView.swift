//
//  PLP.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import SwiftUI

struct PLPView: View {
    @StateObject var viewmodel: PLPViewModel = PLPViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
//                TextField Searh
                CustomTextField(text: $viewmodel.txtSearch, placeholder: "Buscar productos", imageIcon: "magnifyingglass", action: viewmodel.searchProducts)
                Spacer()
                ScrollView {
//                    Scroll in PLP
                    LazyVStack {
                        ForEach(Array(viewmodel.products.enumerated()), id: \.element.id) { index, product in
                            CellProduct(product: product)
                                .onAppear {
                                    if index == viewmodel.products.count - 5 {
                                        viewmodel.loadNextPage()
                                    }
                                }
                        }
                    }
                }
            }
            .padding(10)
        }
        .loader($viewmodel.isLoading)
        .padding(.top, 20)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PLPView()
}
