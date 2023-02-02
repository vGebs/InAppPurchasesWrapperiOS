# InAppPurchaseiOS

`InAppPurchaseiOS` is an iOS class that provides a simple interface for making in-app purchases and restoring already purchased products. The class supports both consumable and non-consumable products, as well as subscriptions.

## Features

- Fetch information about available in-app products from the App Store
- Make in-app purchases
- Restore previously purchased products
- Receive callbacks for each step of the process, including successful and failed purchases, successful and failed restores, and product information fetch completion

## Installation

### Swift Package Manager

- There are currently issues with the package, but the code works.

- Simply copy and paste the contents of the InAppPurchaseiOS file in Sources

## Usage

For testing, use this link for reference: [Testing In-App Purchases with StoreKit 2](https://wwdcbysundell.com/2021/working-with-in-app-purchases-in-storekit2/).

Here is a sample interface, for more info please reference the SampleUsage folder.

```swift 
let productIdentifiers: Set<String> = ["com.example.product1", "com.example.product2", "com.example.product3"]

let callbacks = InAppPurchasesCallbacks(onFetchCompleted: { products in
    // Product information was successfully fetched
}, onProductsNotFound: { invalidProductIdentifiers in
    // One or more product identifiers were not found on the App Store
}, onPurchaseSucceeded: { product in
    // The purchase of the product was successful
}, onPurchaseFailed: { product, error in
    // The purchase of the product failed
}, onRestoreCompleted: { transactions in
    // The restore was successful
}, onRestoreFailed: { error in
    // The restore failed
})

let inAppPurchaseWrapper = InAppPurchaseWrapper(productIdentifiers: productIdentifiers, callbacks: callbacks)
```

To make an in-app purchase, call purchaseProduct and pass it the product you want to purchase.

```swift
let product = ... // The product to purchase
inAppPurchaseWrapper.purchaseProduct(product)
```

To restore previously purchased products, call restorePurchases().

```swift
inAppPurchaseWrapper.restorePurchases()
```

## CallBacks

The following callbacks are available to receive information about the in-app purchase process:

- `onFetchCompleted`: Called when the information about the available products has been successfully fetched from the App Store. The products parameter contains the fetched products.
- `onProductsNotFound`: Called when one or more of the product identifiers passed to InAppPurchaseWrapper were not found on the App Store. The invalidProductIdentifiers parameter contains the invalid product identifiers.
- `onPurchaseSucceeded`: Called when the purchase of a product has been successful. The product parameter is the product that was purchased.
- `onPurchaseFailed`: Called when the purchase of a product has failed. The product parameter is the product that was attempted to be purchased, and the error parameter is the error that occurred during the purchase.
- `onRestoreCompleted`: Called when the restore has been completed successfully. The `trans

## Conclusion

In conclusion, the `InAppPurchaseiOS` is a comprehensive and efficient interface for handling in-app purchases in iOS applications. It provides an easy-to-use API for fetching product information, making purchases, and restoring previous purchases. The interface also offers a range of callbacks to handle different scenarios such as successful purchases, failed purchases, and restored transactions. With the InAppPurchaseWrapper, developers can easily integrate in-app purchases into their applications and handle them in a seamless and streamlined manner.

## License

`InAppPurchaseiOS` is released under the MIT license. See LICENSE for details.

## Contribution

We welcome contributions to `InAppPurchaseiOS`. If you have a bug fix or a new feature, please open a pull request.
