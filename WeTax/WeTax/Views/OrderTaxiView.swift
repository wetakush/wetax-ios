//
//  OrderTaxiView.swift
//  WeTax
//
//  Экран заказа такси
//

import SwiftUI
import MapKit

struct OrderTaxiView: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var rideViewModel = RideViewModel(locationService: LocationService())
    @State private var showCarTypeSelection = false
    @State private var showAddressInput = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173), // Москва
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            // Карта
            MapView(
                region: $region,
                fromLocation: rideViewModel.currentRide?.fromLocation.clLocation,
                toLocation: rideViewModel.currentRide?.toLocation.clLocation,
                driverLocation: rideViewModel.driver?.location.clLocation
            )
            .ignoresSafeArea()
            
            VStack {
                // Панель ввода адресов
                if !showCarTypeSelection && rideViewModel.currentRide == nil {
                    AddressInputPanel(
                        fromAddress: $rideViewModel.fromAddress,
                        toAddress: $rideViewModel.toAddress,
                        onSearch: {
                            showAddressInput = true
                        }
                    )
                    .padding()
                    .transition(.move(edge: .top))
                }
                
                Spacer()
                
                // Панель выбора типа авто и заказа
                if rideViewModel.currentRide == nil {
                    CarTypeSelectionPanel(
                        selectedCarType: $rideViewModel.selectedCarType,
                        estimatedPrice: rideViewModel.estimatedPrice,
                        estimatedTime: rideViewModel.estimatedTime,
                        onOrder: {
                            orderTaxi()
                        }
                    )
                    .padding()
                    .transition(.move(edge: .bottom))
                } else {
                    // Экран ожидания такси
                    WaitingForDriverView(rideViewModel: rideViewModel)
                        .padding()
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .onAppear {
            setupLocation()
            // Обновляем locationService в ViewModel
            rideViewModel.updateLocationService(locationService)
        }
        .sheet(isPresented: $showAddressInput) {
            AddressInputView(
                fromAddress: $rideViewModel.fromAddress,
                toAddress: $rideViewModel.toAddress,
                locationService: locationService
            )
        }
    }
    
    private func setupLocation() {
        locationService.startUpdatingLocation()
        
        if let location = locationService.currentLocation {
            region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    private func orderTaxi() {
        guard let userId = authViewModel.currentUser?.id,
              let userName = authViewModel.currentUser?.name,
              let userPhone = authViewModel.currentUser?.phone,
              let fromLocation = locationService.currentLocation else {
            return
        }
        
        // Для демонстрации используем случайную точку назначения
        let toLocation = CLLocationCoordinate2D(
            latitude: (fromLocation.latitude) + 0.01,
            longitude: (fromLocation.longitude) + 0.01
        )
        
        rideViewModel.calculatePrice(from: fromLocation, to: toLocation)
        rideViewModel.createRide(from: fromLocation, to: toLocation, userId: userId, userName: userName, userPhone: userPhone)
    }
}

// MARK: - Address Input Panel
struct AddressInputPanel: View {
    @Binding var fromAddress: String
    @Binding var toAddress: String
    var onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.black)
                    .font(.title3)
                
                VStack(spacing: 8) {
                    HStack {
                        Circle()
                            .fill(Color(hex: "007AFF"))
                            .frame(width: 8, height: 8)
                        
                        TextField("От: Комарова 9", text: $fromAddress)
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 8, height: 8)
                        
                        TextField("Куда?", text: $toAddress)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .onTapGesture {
                                onSearch()
                            }
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Car Type Selection Panel
struct CarTypeSelectionPanel: View {
    @Binding var selectedCarType: CarType
    var estimatedPrice: Double
    var estimatedTime: Int
    var onOrder: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Выбор типа авто в виде карточек
            HStack(spacing: 12) {
                ForEach(CarType.allCases, id: \.self) { carType in
                    Button(action: {
                        selectedCarType = carType
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: carType.icon)
                                .font(.title3)
                            
                            Text(carType.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            Text("\(Int(calculatePrice(for: carType))) ₽")
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedCarType == carType ? Color(hex: "007AFF") : Color.white)
                        .foregroundColor(selectedCarType == carType ? .white : .black)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedCarType == carType ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: selectedCarType == carType ? Color(hex: "007AFF").opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                    }
                }
            }
            
            // Информация о поездке
            if estimatedPrice > 0 {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Откуда")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Комарова 9")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Куда")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Куряночка • \(estimatedTime) мин")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
            }
            
            // Кнопка заказа
            HStack {
                // Логотип
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.yellow)
                        .frame(width: 30, height: 30)
                    Text("T")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                
                Button(action: onOrder) {
                    Text("Вызвать")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                // Иконка настроек
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -2)
    }
    
    private func calculatePrice(for carType: CarType) -> Double {
        if estimatedPrice > 0 {
            let multiplier: Double
            switch carType {
            case .economy: multiplier = 1.0
            case .comfort: multiplier = 1.4
            case .business: multiplier = 2.0
            }
            return estimatedPrice * multiplier
        }
        return carType.basePrice
    }
}

