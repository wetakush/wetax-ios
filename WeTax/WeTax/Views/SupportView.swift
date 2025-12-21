//
//  SupportView.swift
//  WeTax
//
//  Экран поддержки
//

import SwiftUI
import MapKit

struct SupportView: View {
    @State private var selectedRide: Ride?
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Карта с маршрутом (если есть выбранная поездка)
                if let ride = selectedRide {
                    MapView(
                        region: $mapRegion,
                        fromLocation: ride.fromLocation.clLocation,
                        toLocation: ride.toLocation.clLocation,
                        driverLocation: nil
                    )
                    .frame(height: 200)
                    .onAppear {
                        mapRegion = MKCoordinateRegion(
                            center: ride.fromLocation.clLocation,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    }
                    
                    // Детали поездки
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Вечером, в \(formatTime(ride.createdAt))")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text("\(Int(ride.price)) Р, \(ride.fromAddress), \(ride.toAddress)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "car.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                }
                
                // Категории вопросов
                VStack(spacing: 0) {
                    SupportCategoryRow(title: "Дополнительные вопросы", icon: "questionmark.circle.fill")
                    SupportCategoryRow(title: "Технические проблемы", icon: "wrench.fill")
                    SupportCategoryRow(title: "Вопросы о платежах", icon: "creditcard.fill")
                    SupportCategoryRow(title: "Отзыв о водителе или автомобиле", icon: "star.fill")
                    SupportCategoryRow(title: "Безопасность", icon: "shield.fill")
                    SupportCategoryRow(title: "Забытые вещи", icon: "bag.fill")
                    SupportCategoryRow(title: "Частые вопросы", icon: "questionmark.bubble.fill")
                    SupportCategoryRow(title: "Получить чек", icon: "doc.text.fill")
                    SupportCategoryRow(title: "Сообщения службы поддержки", icon: "message.fill")
                    SupportCategoryRow(title: "Посмотреть все сообщения", icon: "envelope.fill")
                }
                .background(Color.white)
            }
        }
        .background(Color.gray.opacity(0.1))
        .navigationTitle("Служба поддержки")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct SupportCategoryRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "007AFF"))
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .bottom
        )
    }
}

