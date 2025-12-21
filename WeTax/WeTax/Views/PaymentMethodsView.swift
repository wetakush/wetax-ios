//
//  PaymentMethodsView.swift
//  WeTax
//
//  Экран способов оплаты
//

import SwiftUI

struct PaymentMethodsView: View {
    @State private var selectedMethod: PaymentMethod = .sbpTinkoff
    @State private var defaultTip: Int = 0
    
    var body: some View {
        List {
            Section("Карты и счета") {
                PaymentMethodRow(
                    method: .sbpSberbank,
                    isSelected: selectedMethod == .sbpSberbank,
                    iconColor: .green
                ) {
                    selectedMethod = .sbpSberbank
                }
                
                PaymentMethodRow(
                    method: .sbpTinkoff,
                    isSelected: selectedMethod == .sbpTinkoff,
                    iconColor: .yellow
                ) {
                    selectedMethod = .sbpTinkoff
                }
                
                HStack {
                    Image(systemName: "banknote.fill")
                        .foregroundColor(.green)
                        .frame(width: 30)
                    
                    Text("Чаевые по умолчанию")
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            if defaultTip > 0 {
                                defaultTip -= 5
                            }
                        }) {
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        
                        Text("\(defaultTip)%")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .frame(minWidth: 40)
                        
                        Button(action: {
                            if defaultTip < 100 {
                                defaultTip += 5
                            }
                        }) {
                            Image(systemName: "chevron.up")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.black)
                }
            }
            
            Section("Другие способы") {
                PaymentMethodRow(
                    method: .cash,
                    isSelected: selectedMethod == .cash,
                    iconColor: .green
                ) {
                    selectedMethod = .cash
                }
            }
        }
        .navigationTitle("Способы оплаты")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Изменить") {
                    // Редактирование
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: {}) {
                Text("Привязать карту")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
            }
            .padding()
            .background(Color.white)
        }
    }
}

enum PaymentMethod: String {
    case sbpSberbank = "СБП • Сбербанк"
    case sbpTinkoff = "СБП • Т-Банк"
    case cash = "Наличные"
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Иконка метода оплаты
                if method == .sbpSberbank {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 30, height: 30)
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                } else if method == .sbpTinkoff {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.yellow)
                            .frame(width: 30, height: 30)
                        Text("T")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                } else {
                    Image(systemName: "banknote.fill")
                        .foregroundColor(iconColor)
                        .frame(width: 30)
                }
                
                Text(method.rawValue)
                    .foregroundColor(.black)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

