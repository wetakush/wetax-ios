//
//  ContentView.swift
//  WeTax
//
//  Главный экран с навигацией
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            OrderTaxiView()
                .tabItem {
                    Label("Заказать", systemImage: "car.fill")
                }
                .tag(0)
            
            RideHistoryView()
                .tabItem {
                    Label("История", systemImage: "clock.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(2)
        }
        .accentColor(Color(hex: "007AFF"))
    }
}

