//
//  TelegramService.swift
//  WeTax
//
//  Сервис для отправки уведомлений в Telegram бота
//

import Foundation

class TelegramService {
    // Замените на токен вашего бота и chat_id
    private let botToken = "7649339716:AAFxjGYphlOojTfQ4HiCBfVNOk3s7up44uM"
    private let chatId = "7457080495"
    private let baseURL = "https://api.telegram.org/bot"
    
    func sendRideNotification(ride: Ride, userName: String, userPhone: String) {
        let message = """
        🚕 Новый заказ такси
        
        👤 Клиент: \(userName)
        📱 Телефон: \(userPhone)
        
        📍 Откуда: \(ride.fromAddress)
        🎯 Куда: \(ride.toAddress)
        
        🚗 Тип авто: \(ride.carType.rawValue)
        💰 Стоимость: \(Int(ride.price))₽
        
        🆔 ID поездки: \(ride.id)
        """
        
        sendMessage(text: message)
    }
    
    private func sendMessage(text: String) {
        guard botToken != "YOUR_BOT_TOKEN", chatId != "YOUR_CHAT_ID" else {
            print("⚠️ Telegram бот не настроен. Установите botToken и chatId в TelegramService.swift")
            return
        }
        
        let urlString = "\(baseURL)\(botToken)/sendMessage"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "chat_id": chatId,
            "text": text,
            "parse_mode": "HTML"
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка отправки в Telegram: \(error.localizedDescription)")
            } else if let data = data {
                print("Telegram ответ: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
    }
}

