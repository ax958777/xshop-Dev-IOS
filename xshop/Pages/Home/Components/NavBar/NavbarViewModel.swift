//
//  NavbarViewModel.swift
//  xshop
//
//  Created by AlexX on 2024-12-07.
//

import Foundation
import SwiftUI

class NavbarViewModel: ObservableObject {
    @Published var isMenuOpen = false
    @Published var isUserMenuOpen = false
    @Published var userName = "John Doe"
    @Published var selectedMenu : MenuAction = .home
    
    static let shared=NavbarViewModel()
    
    func toggleMenu() {
        withAnimation {
            isMenuOpen.toggle()
        }
    }
    
    func toggleUserMenu() {
        withAnimation {
            isUserMenuOpen.toggle()
        }
    }
    
    func handleMenuAction(_ action: MenuAction) {
        // Close menu after action
        isMenuOpen = false
        
        // Handle different menu actions
        switch action {
        case .home:
            self.selectedMenu = .home
            print("Navigating to Home")
        case .plantIdentifier:
            self.selectedMenu = .plantIdentifier
            print("Navigating to Plant Identifier")
        case .models:
            self.selectedMenu = .models
            print("Navigating to 3d Models")
        case .profile:
            print("Navigating to Profile")
        case .settings:
            print("Opening Settings")
        case .notifications:
            print("Opening Notifications")
        }
    }
}


