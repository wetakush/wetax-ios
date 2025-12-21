//
//  WaitingForDriverView.swift
//  WeTax
//
//  Экран ожидания водителя
//

import SwiftUI

struct WaitingForDriverView: View {
    @ObservedObject var rideViewModel: RideViewModel
    @State private var progress: Double = 0
    @State private var showCompletion = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Статус поездки
            VStack(spacing: 12) {
                if rideViewModel.isSearchingDriver {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color(hex: "007AFF"))
                    
                    Text(rideViewModel.currentRide?.status.rawValue ?? "Поиск водителя")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("Ищем подходящего водителя...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                } else if let driver = rideViewModel.driver {
                    // Информация о водителе
                    VStack(spacing: 16) {
                        // Аватар водителя
                        Circle()
                            .fill(Color(hex: "007AFF").opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(driver.name.prefix(1))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "007AFF"))
                            )
                        
                        Text(driver.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        // Звезды рейтинга
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(driver.rating) ? "star.fill" : "star")
                                    .foregroundColor(index < Int(driver.rating) ? .yellow : .gray.opacity(0.3))
                                    .font(.caption)
                            }
                            Text(String(format: "%.1f", driver.rating))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        
                        // Информация об авто
                        HStack(spacing: 20) {
                            VStack {
                                Text("Автомобиль")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(driver.carModel)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                            
                            VStack {
                                Text("Номер")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(driver.carNumber)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Кнопка звонка
                        Button(action: {
                            if let phone = rideViewModel.currentRide?.driverPhone {
                                if let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Позвонить водителю")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "007AFF"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        // Кнопка выбора музыки (только для бизнеса)
                        if rideViewModel.currentRide?.carType == .business && rideViewModel.currentRide?.status == .inProgress {
                            Button(action: {
                                rideViewModel.showMusicSelection = true
                            }) {
                                HStack {
                                    Image(systemName: "music.note")
                                    Text("Выбрать музыку")
                                }
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple.opacity(0.2))
                                .foregroundColor(.purple)
                                .cornerRadius(12)
                            }
                        }
                        
                        // Кнопка завершения поездки (для симуляции)
                        if rideViewModel.currentRide?.status == .inProgress {
                            Button(action: {
                                // Симулируем завершение поездки
                                if var ride = rideViewModel.currentRide {
                                    ride.status = .completed
                                    ride.completedAt = Date()
                                    rideViewModel.completeRide()
                                    showCompletion = true
                                }
                            }) {
                                Text("Завершить поездку")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            
            // Кнопка отмены
            if rideViewModel.currentRide?.status != .completed {
                Button(action: {
                    rideViewModel.cancelRide()
                }) {
                    Text("Отменить поездку")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                }
            }
        }
        .sheet(isPresented: $showCompletion) {
            if let ride = rideViewModel.ridesHistory.first, let driver = rideViewModel.driver {
                RideCompletionView(ride: ride, driver: driver)
            } else if let ride = rideViewModel.currentRide, let driver = rideViewModel.driver {
                RideCompletionView(ride: ride, driver: driver)
            }
        }
        .sheet(isPresented: $rideViewModel.showMusicSelection) {
            MusicSelectionView()
        }
    }
}

