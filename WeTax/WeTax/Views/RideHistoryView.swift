//
//  RideHistoryView.swift
//  WeTax
//
//  Экран истории поездок
//

import SwiftUI

struct RideHistoryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var rideViewModel = RideViewModel(locationService: LocationService())
    
    var groupedRides: [String: [Ride]] {
        Dictionary(grouping: rideViewModel.ridesHistory) { ride in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            
            if Calendar.current.isDateInToday(ride.createdAt) {
                return "Сегодня"
            } else if Calendar.current.isDateInYesterday(ride.createdAt) {
                return "Вчера"
            } else {
                formatter.dateFormat = "d MMMM, EEEE"
                return formatter.string(from: ride.createdAt)
            }
        }
    }
    
    var sortedKeys: [String] {
        groupedRides.keys.sorted { key1, key2 in
            let date1 = getDate(for: key1)
            let date2 = getDate(for: key2)
            return date1 > date2
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if rideViewModel.ridesHistory.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "clock.badge.xmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("История поездок пуста")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text("Ваши поездки будут отображаться здесь")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(sortedKeys, id: \.self) { key in
                                if let rides = groupedRides[key] {
                                    Section(header: Text(key)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)) {
                                        ForEach(rides) { ride in
                                            RideHistoryRow(ride: ride)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .background(Color.gray.opacity(0.1))
                }
            }
            .navigationTitle("История поездок")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func getDate(for key: String) -> Date {
        if key == "Сегодня" {
            return Date()
        } else if key == "Вчера" {
            return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM, EEEE"
            return formatter.date(from: key) ?? Date()
        }
    }
}

struct RideHistoryRow: View {
    let ride: Ride
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: ride.carType.icon)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Такси \(ride.carType.rawValue), \(formatTime(ride.createdAt))")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        if ride.status == .cancelled {
                            Text("Отменено")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Text("\(ride.fromAddress), \(ride.toAddress)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text(ride.status == .cancelled ? "0 ₽" : "\(Int(ride.price)) ₽")
                    .font(.headline)
                    .foregroundColor(ride.status == .cancelled ? .gray : Color(hex: "007AFF"))
            }
            
            // Кнопки действий (только для завершенных поездок)
            if ride.status == .completed {
                HStack(spacing: 12) {
                    Button(action: {
                        if let phone = ride.driverPhone {
                            if let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Позвонить")
                        }
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "headphones")
                            Text("Помощь")
                        }
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
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
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func statusColor(_ status: RideStatus) -> Color {
        switch status {
        case .completed:
            return .green
        case .cancelled:
            return .red
        case .inProgress:
            return .blue
        default:
            return .orange
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }
}

