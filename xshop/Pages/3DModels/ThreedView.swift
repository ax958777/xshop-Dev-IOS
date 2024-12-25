//
//  ThreedView.swift
//  xshop
//
//  Created by AlexX on 2024-12-23.
//

import SwiftUI
import Model3DView
import Kingfisher

// Models
struct Product: Identifiable {
    let id : String
    let name: String
    let price: Double
    let rating: Int
    let imageName: String?
    let category: ProductCategory
}

enum ProductCategory: String, CaseIterable {
    case construction = "Construction"
    case machine = "Machine"
    case products = "Products"
    case games = "Games"
    case cosmics = "Cosmics"
}

// let cat=ProductCategory(rawValue: row.category);  // Get enum from rawValue

// ViewModel
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var selectedCategory: ProductCategory?
    
    init() {
        Task{
            try await loadProducts()
        }
        
    }
    @MainActor
    private  func loadProducts() async throws{
        // Sample data
//        products = [
//            Product(id:"a",name: "f18", price: 0, rating: 5, imageName: "f18", category: .products),
//            Product(id:"b",name: "f18", price: 0, rating: 5, imageName: "f18", category: .products),
//            Product(id:"c",name: "f18", price: 0, rating: 5, imageName: "f18", category: .products),
//            // Add more products here
//        ]
        self.products = try await ModelingService.fetchModelings();
    
    }
    
    func filterProducts() -> [Product] {
        guard let category = selectedCategory else {
            return products
        }
        return products.filter { $0.category == category }
    }
}

// Views
struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    
    var body: some View {
        VStack {
            HeaderView()
            CategoryFilterView(selectedCategory: $viewModel.selectedCategory)
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filterProducts()) { product in
                        ProductCard(product: product)
                    }
                }
                .padding()
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        ZStack {
            Color("AccentColor")
            Text("3D Models")
                .font(.title)
                .foregroundColor(.white)
                .padding()
        }
        .frame(height: 60)
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: ProductCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category ? nil : category
                    }) {
                        Text(category.rawValue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedCategory == category ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                            )
                            .foregroundColor(selectedCategory == category ? .green : .primary)
                    }
                }
            }
            .padding()
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack {
            if let imageUrl=product.imageName{
                       KFImage(URL(string: imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                    }else{
                        Image("f18")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding()
                    }
           
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(product.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.headline)
                
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < product.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                
                Button(action: {}) {
                    Text("Buy")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
