//
//  LoginView.swift
//  WeTax
//
//  Экран авторизации
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                colors: [Color(hex: "007AFF"), Color(hex: "0051D5")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Логотип
                VStack(spacing: 20) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("WeTax")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Быстро. Удобно. Надежно")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Форма входа
                VStack(spacing: 20) {
                    // Поле телефона
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        TextField("+7 (999) 123-45-67", text: $viewModel.phone)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    // Поле пароля
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        SecureField("Пароль", text: $viewModel.password)
                            .textContentType(.password)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    // Ошибка
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    // Кнопка входа
                    Button(action: {
                        viewModel.login()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Войти")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color(hex: "007AFF"))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Демо-кнопка для быстрого входа
                Button(action: {
                    viewModel.phone = "+7 (999) 123-45-67"
                    viewModel.password = "123456"
                    viewModel.login()
                }) {
                    Text("Войти как демо-пользователь")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 30)
            }
        }
    }
}

