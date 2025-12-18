//
//  User.swift
//  WeTax
//
//  Модель пользователя
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var phone: String
    var name: String
    var email: String?
    var avatarURL: String?
    
    init(id: String = UUID().uuidString, phone: String, name: String, email: String? = nil) {
        self.id = id
        self.phone = phone
        self.name = name
        self.email = email
    }
}

