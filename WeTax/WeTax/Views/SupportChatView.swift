//
//  SupportChatView.swift
//  WeTax
//
//  Экран чата с техподдержкой
//

import SwiftUI

struct SupportChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Здравствуйте! Чем могу помочь?", isFromUser: false, timestamp: Date())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isFromUser {
                                Spacer()
                            }
                            
                            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                                Text(message.text)
                                    .padding()
                                    .background(message.isFromUser ? Color(hex: "007AFF") : Color.gray.opacity(0.2))
                                    .foregroundColor(message.isFromUser ? .white : .black)
                                    .cornerRadius(16)
                                
                                Text(formatTime(message.timestamp))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            
                            if !message.isFromUser {
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack(spacing: 12) {
                TextField("Напишите сообщение...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(messageText.isEmpty ? Color.gray : Color(hex: "007AFF"))
                        .cornerRadius(20)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
            .background(Color.white)
        }
        .navigationTitle("Поддержка")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let userMessage = ChatMessage(text: messageText, isFromUser: true, timestamp: Date())
        messages.append(userMessage)
        
        let userText = messageText
        messageText = ""
        
        // Симуляция ответа поддержки
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = generateResponse(for: userText)
            messages.append(ChatMessage(text: response, isFromUser: false, timestamp: Date()))
        }
    }
    
    private func generateResponse(for text: String) -> String {
        let lowercased = text.lowercased()
        
        if lowercased.contains("отмена") || lowercased.contains("отменить") {
            return "Для отмены поездки нажмите кнопку 'Отменить поездку' в приложении."
        } else if lowercased.contains("оплата") || lowercased.contains("деньги") {
            return "Оплата происходит автоматически через выбранный способ оплаты после завершения поездки."
        } else if lowercased.contains("водитель") || lowercased.contains("машина") {
            return "Вы можете связаться с водителем по телефону, нажав кнопку 'Позвонить водителю'."
        } else {
            return "Спасибо за обращение! Мы обработаем ваш запрос и свяжемся с вами в ближайшее время."
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

