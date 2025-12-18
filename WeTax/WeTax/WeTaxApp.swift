//
//  WeTaxApp.swift
//  WeTax
//
//  Главный файл приложения
//

import SwiftUI

@main
struct WeTaxApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var locationService = LocationService()
    @StateObject private var notificationService = NotificationService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(locationService)
                .environmentObject(notificationService)
                .onAppear {
                    // Запрашиваем разрешения при запуске
                    locationService.requestAuthorization()
                    notificationService.requestAuthorization()
                }
        }
    }
}

