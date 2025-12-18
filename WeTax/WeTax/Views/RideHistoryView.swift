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
                    List {
                        ForEach(rideViewModel.ridesHistory) { ride in
                            RideHistoryRow(ride: ride)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("История поездок")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct RideHistoryRow: View {
    let ride: Ride
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: ride.carType.icon)
                    .foregroundColor(Color(hex: "007AFF"))
                
                Text(ride.carType.rawValue)
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(ride.price))₽")
                    .font(.headline)
                    .foregroundColor(Color(hex: "007AFF"))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Circle()
                        .fill(Color(hex: "007AFF"))
                        .frame(width: 6, height: 6)
                    Text(ride.fromAddress)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 6, height: 6)
                    Text(ride.toAddress)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Text(ride.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(ride.status).opacity(0.2))
                    .foregroundColor(statusColor(ride.status))
                    .cornerRadius(8)
                
                Spacer()
                
                if let date = ride.completedAt ?? ride.createdAt {
                    Text(dateFormatter.string(from: date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
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

