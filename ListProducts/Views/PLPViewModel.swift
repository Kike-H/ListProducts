//
//  PLPViewModel.swift
//  ListProducts
//
//  Created by Kike Hernandez D. on 26/11/24.
//

import Foundation

final class PLPViewModel: BaseViewModel {
    
    var page: Int = 1
    var isFetching: Bool = false
    @Published var txtSearch: String = ""
    @Published var sort: String?
    @Published var products: Products = [] {
        didSet {
            self.isLoading = false
        }
    }
    
    func getProducts() {
        let completion: LSResponse<Result> = { [weak self] response in
            guard let weak = self else { return }
            weak.isFetching = false
            switch response {
            case .success(let result):
                if weak.page == 1 {
                    weak.products = result.plpResults?.records ?? []
                } else {
                    weak.products.append(contentsOf: result.plpResults?.records ?? [])
                }
            case .failure(let error):
                weak.products = weak.products
                let msg = weak.getAFError(error: error)
                debugPrint(msg)
            }
        }
        self.isFetching = true
        self.isLoading = true
        API.getProducts(txtSearch: self.txtSearch, page: self.page, sort: sort).execute(completion: completion)
    }
    
    func searchProducts() {
        self.page = 1
        self.getProducts()
    }
    
    func loadNextPage() {
            guard !isFetching else { return } // Evita llamadas simultáneas
            page += 1
            getProducts()
        }
    
}
