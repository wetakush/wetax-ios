//
//  AuthViewModel.swift
//  WeTax
//
//  ViewModel для авторизации
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Проверяем сохраненную сессию
        checkSavedSession()
    }
    
    func login() {
        guard !phone.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Симуляция авторизации (в реальном приложении здесь будет API запрос)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Мок-данные для демонстрации
            self.currentUser = User(
                phone: self.phone,
                name: "Иван Иванов",
                email: "ivan@example.com"
            )
            
            // Сохраняем сессию
            UserDefaults.standard.set(self.currentUser?.id, forKey: "userId")
            UserDefaults.standard.set(self.phone, forKey: "userPhone")
            
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        phone = ""
        password = ""
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userPhone")
    }
    
    private func checkSavedSession() {
        if let userId = UserDefaults.standard.string(forKey: "userId"),
           let userPhone = UserDefaults.standard.string(forKey: "userPhone") {
            // Восстанавливаем сессию
            currentUser = User(id: userId, phone: userPhone, name: "Иван Иванов")
            isAuthenticated = true
        }
    }
}

