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
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Профиль пользователя
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(authViewModel.currentUser?.name ?? "Пользователь")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Text(authViewModel.currentUser?.phone ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        
                        // Меню
                        VStack(spacing: 0) {
                            ProfileMenuItem(
                                title: "История заказов",
                                icon: "clock.fill",
                                destination: AnyView(RideHistoryView())
                            )
                            
                            ProfileMenuItem(
                                title: "Способы оплаты",
                                icon: "creditcard.fill",
                                subtitle: "СБП · Т-Банк",
                                iconColor: .yellow,
                                destination: AnyView(PaymentMethodsView())
                            )
                            
                            ProfileMenuItem(
                                title: "Служба поддержки",
                                icon: "headphones",
                                destination: AnyView(SupportView())
                            )
                            
                            ProfileMenuItem(
                                title: "Мои адреса",
                                icon: "mappin.circle.fill",
                                destination: AnyView(AddressesView())
                            )
                            
                            ProfileMenuItem(
                                title: "Скидки и подарки",
                                icon: "gift.fill",
                                subtitle: "Ввести промокод",
                                destination: AnyView(PromoCodesView())
                            )
                            
                            ProfileMenuItem(
                                title: "Настройки",
                                icon: "gearshape.fill",
                                destination: AnyView(SettingsView())
                            )
                            
                            ProfileMenuItem(
                                title: "Информация",
                                icon: "info.circle.fill",
                                destination: AnyView(AboutView())
                            )
                        }
                        .background(Color.white)
                        .padding(.top, 8)
                        
                        // Кнопка выхода
                        Button(action: {
                            authViewModel.logout()
                        }) {
                            Text("Выйти")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileMenuItem: View {
    let title: String
    let icon: String
    var subtitle: String? = nil
    var iconColor: Color = Color(hex: "007AFF")
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(.black)
                        .font(.body)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.gray.opacity(0.2)),
                alignment: .bottom
            )
        }
    }
}

struct AddressesView: View {
    var body: some View {
        List {
            Text("Мои адреса")
        }
        .navigationTitle("Мои адреса")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PromoCodesView: View {
    var body: some View {
        List {
            Text("Промокоды")
        }
        .navigationTitle("Скидки и подарки")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView: View {
    var body: some View {
        List {
            Text("Настройки")
        }
        .navigationTitle("Настройки")
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

