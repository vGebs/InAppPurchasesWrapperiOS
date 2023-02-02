//
//  File.swift
//  
//
//  Created by Vaughn on 2023-02-02.
//

import Foundation
import StoreKit

@available(iOS 13.0, *)
class InAppPurchasesService: ObservableObject {
    private var inAppPurchases: InAppPurchaseWrapper?
    
    @Published var products: [SKProduct] = []
    
    init(productIdentifiers: Set<String>) {
        let callbacks = InAppPurchaseWrapper.InAppPurchasesCallbacks(onFetchCompleted: { [weak self] products in
            // handle fetching completed
            for product in products {
                print("product: \(product.localizedTitle) - \(product.price)")
                DispatchQueue.main.async {
                    self?.products.append(product)
                }
            }
        }, onProductsNotFound: { skus in
            // handle product not found
            if let skus = skus {
                for sku in skus {
                    print("Could not find product with sku: \(sku)")
                }
            } else {
                print("product not found")
            }
        }, onPurchaseSucceeded: { product in
            // handle purchase succeeded
            print("purchase succeeded for product: \(product.localizedTitle)")
        }, onPurchaseFailed: { product, error in
            // handle purchase failed
            print("purchase failed for product: \(product.localizedTitle) - \(error?.localizedDescription ?? "")")
        }, onRestoreCompleted: { transactions in
            // handle restore completed
            for transaction in transactions {
                print("product: \(transaction.payment.productIdentifier)")
            }
        }, onRestoreFailed: { error in
            // handle restore failed
            print("restore failed: \(error?.localizedDescription ?? "")")
        })
        
        inAppPurchases = InAppPurchaseWrapper(productIdentifiers: productIdentifiers, callbacks: callbacks)
    }
    
    func purchase(product: SKProduct) {
        inAppPurchases!.purchaseProduct(product)
    }
    
    func restore() {
        inAppPurchases!.restorePurchases()
    }
}
