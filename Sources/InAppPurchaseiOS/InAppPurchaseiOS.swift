import Foundation
import StoreKit

public class InAppPurchaseWrapper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private var products = [SKProduct]()
    private var callbacks: InAppPurchasesCallbacks
    private var productIdentifiers: Set<String>
    
    public struct InAppPurchasesCallbacks {
        var onFetchCompleted: (([SKProduct]) -> Void)?
        var onProductsNotFound: (([String]?) -> Void)?
        var onPurchaseSucceeded: ((SKProduct) -> Void)?
        var onPurchaseFailed: ((SKProduct, Error?) -> Void)?
        var onRestoreCompleted: (([SKPaymentTransaction]) -> Void)?
        var onRestoreFailed: ((Error?) -> Void)?
    }
    
    public init(productIdentifiers: Set<String>, callbacks: InAppPurchasesCallbacks) {
        self.productIdentifiers = productIdentifiers
        self.callbacks = callbacks
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProductInfo()
    }
    
    private func fetchProductInfo() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    public func purchaseProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - Delegate methods
extension InAppPurchaseWrapper {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        let unrecognized = response.invalidProductIdentifiers
        
        if products.count == 0 {
            if unrecognized.count > 0 {
                callbacks.onProductsNotFound?(unrecognized)
            } else {
                callbacks.onProductsNotFound?(nil)
            }
        } else {
            callbacks.onFetchCompleted?(products)
            
            if unrecognized.count > 0{
                callbacks.onProductsNotFound?(unrecognized)
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                let product = products.first {
                    $0.productIdentifier == transaction.payment.productIdentifier
                }
                
                if let p = product {
                    callbacks.onPurchaseSucceeded?(p)
                } else {
                    callbacks.onProductsNotFound?(nil)
                }
                queue.finishTransaction(transaction)
            case .failed:
                let product = products.first {
                    $0.productIdentifier == transaction.payment.productIdentifier
                }
                
                if let p = product, let e = transaction.error {
                    callbacks.onPurchaseFailed?(p, e)
                } else {
                    callbacks.onProductsNotFound?(nil)
                }
                queue.finishTransaction(transaction)
            case .restored:
                let product = products.first {
                    $0.productIdentifier == transaction.original?.payment.productIdentifier
                }
                if let p = product {
                    callbacks.onPurchaseSucceeded?(p)
                } else {
                    callbacks.onProductsNotFound?(nil)
                }
                queue.finishTransaction(transaction)
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        callbacks.onRestoreFailed?(error)
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        callbacks.onRestoreCompleted?(queue.transactions)
    }
}

