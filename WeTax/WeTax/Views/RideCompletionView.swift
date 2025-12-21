//
//  RideCompletionView.swift
//  WeTax
//
//  Экран завершения поездки с рейтингом и чаевыми
//

import SwiftUI

struct RideCompletionView: View {
    let ride: Ride
    let driver: Driver
    @State private var rating: Int = 0
    @State private var selectedTip: Int = 0
    @State private var showCompletion = false
    @Environment(\.dismiss) var dismiss
    
    let tipOptions = [0, 20, 30, 60, 100]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Заголовок с суммой
                VStack(spacing: 8) {
                    Text("Вы приехали")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("\(Int(ride.price)) ₽")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.top, 20)
                
                // Водитель и авто
                HStack(spacing: 16) {
                    // Иконка авто
                    ZStack(alignment: .trailing) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        // Аватар водителя
                        Circle()
                            .fill(Color(hex: "007AFF").opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(driver.name.prefix(1))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "007AFF"))
                            )
                            .offset(x: 20, y: -10)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(driver.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(driver.carModel)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Рейтинг
                VStack(spacing: 12) {
                    Text("Как вам поездка?")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("Ваш отзыв останется анонимным")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { index in
                            Button(action: {
                                rating = index
                            }) {
                                Image(systemName: index <= rating ? "star.fill" : "star")
                                    .font(.system(size: 32))
                                    .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.3))
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
                
                // Чаевые
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(driver.name) получит все чаевые")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Чаевые водителю")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 12) {
                        ForEach(tipOptions, id: \.self) { tip in
                            Button(action: {
                                selectedTip = tip
                            }) {
                                Text(tip == 0 ? "Без чаевых" : "\(tip) ₽")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedTip == tip ? .white : .black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedTip == tip ? Color(hex: "007AFF") : Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Детали оплаты
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.yellow)
                        Text("СБП: \(Int(ride.price)) ₽")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.gray)
                            Text("Перевозчик и детали")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text("Индивидуальный предприниматель")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Кнопка готово
                Button(action: {
                    showCompletion = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                }) {
                    Text("Готово")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .background(Color.white)
    }
}

