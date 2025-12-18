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
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", driver.rating))
                                .fontWeight(.medium)
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
                            }
                            
                            VStack {
                                Text("Номер")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(driver.carNumber)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
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
    }
}

