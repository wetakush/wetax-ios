//
//  ProfileView.swift
//  WeTax
//
//  Экран профиля пользователя
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                // Профиль пользователя
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(hex: "007AFF").opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(authViewModel.currentUser?.name.prefix(1) ?? "U")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "007AFF"))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authViewModel.currentUser?.name ?? "Пользователь")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text(authViewModel.currentUser?.phone ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Настройки
                Section("Настройки") {
                    NavigationLink(destination: PaymentMethodsView()) {
                        Label("Способы оплаты", systemImage: "creditcard.fill")
                    }
                    
                    NavigationLink(destination: NotificationsSettingsView()) {
                        Label("Уведомления", systemImage: "bell.fill")
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Label("О приложении", systemImage: "info.circle.fill")
                    }
                }
                
                // Выход
                Section {
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Выйти")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(Color(hex: "007AFF"))
                    Text("Карта •••• 1234")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            } header: {
                Text("Текущий способ оплаты")
            }
            
            Section {
                Button(action: {}) {
                    Label("Добавить карту", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("Способы оплаты")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsSettingsView: View {
    @State private var pushEnabled = true
    @State private var emailEnabled = false
    
    var body: some View {
        List {
            Section {
                Toggle("Push-уведомления", isOn: $pushEnabled)
                Toggle("Email-уведомления", isOn: $emailEnabled)
            } header: {
                Text("Уведомления")
            } footer: {
                Text("Получайте уведомления о статусе поездки и специальных предложениях")
            }
        }
        .navigationTitle("Уведомления")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Версия")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
            }
            
            Section {
                Link("Политика конфиденциальности", destination: URL(string: "https://wetax.ru/privacy")!)
                Link("Условия использования", destination: URL(string: "https://wetax.ru/terms")!)
            }
        }
        .navigationTitle("О приложении")
        .navigationBarTitleDisplayMode(.inline)
    }
}

