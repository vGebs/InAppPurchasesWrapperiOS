//
//  File.swift
//  
//
//  Created by Vaughn on 2023-02-02.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Products")
                    .padding()
                
                Spacer()
                
                Button(action: {
                    viewModel.restore()
                }) {
                    Text("Restore Purchases")
                        .padding()
                }
            }
            ScrollView {
                ForEach(viewModel.products, id: \.self) { product in
                    Text("Item name: \(product.localizedTitle)")
                    Text("Price: $\(product.price)")
                    
                    Button(action: {
                        viewModel.purchase(product)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 3)
                                .frame(width: 150, height: 20)
                            Text("Purchase")
                        }
                    }
                    Divider().padding(.bottom)
                }
            }
        }
    }
}
