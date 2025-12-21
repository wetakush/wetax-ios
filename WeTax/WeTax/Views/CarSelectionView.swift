//
//  CarSelectionView.swift
//  WeTax
//
//  Экран выбора машины для бизнеса
//

import SwiftUI

struct CarSelectionView: View {
    @ObservedObject var rideViewModel: RideViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Выберите автомобиль")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    ForEach(rideViewModel.availableDrivers, id: \.id) { driver in
                        Button(action: {
                            rideViewModel.selectCarAndDriver(carModel: driver.carModel)
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(driver.carModel)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        // Звезды рейтинга
                                        ForEach(0..<5) { index in
                                            Image(systemName: index < Int(driver.rating) ? "star.fill" : "star")
                                                .foregroundColor(index < Int(driver.rating) ? .yellow : .gray.opacity(0.3))
                                                .font(.caption)
                                        }
                                        Text(String(format: "%.1f", driver.rating))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text("Водитель: \(driver.name)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Выбор автомобиля")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

