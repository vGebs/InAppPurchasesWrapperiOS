//
//  File.swift
//  
//
//  Created by Vaughn on 2023-02-02.
//

import Foundation
import Combine
import StoreKit

@available(iOS 13.0, *)
class ViewModel: ObservableObject {
    var identifiers: Set<String> = Set()
    
    @Published private(set) var products: [SKProduct] = []
    
    let iapService: InAppPurchasesService
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        
        self.identifiers.insert("com.temporary.id")
        self.identifiers.insert("com.temporary.nonconsumable")
        self.identifiers.insert("com.temporary.autoRenew")
        
        
        self.iapService = InAppPurchasesService(productIdentifiers: identifiers)
        
        self.iapService.$products.receive(on: DispatchQueue.main).sink { [weak self] products in
            self?.products = products
        }.store(in: &cancellables)
    }
    
    func purchase(_ product: SKProduct) {
        iapService.purchase(product: product)
    }
    
    func restore() {
        iapService.restore()
    }
}

