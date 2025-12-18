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
              let fromLocation = locationService.currentLocation else {
            return
        }
        
        // Для демонстрации используем случайную точку назначения
        let toLocation = CLLocationCoordinate2D(
            latitude: (fromLocation.latitude) + 0.01,
            longitude: (fromLocation.longitude) + 0.01
        )
        
        rideViewModel.calculatePrice(from: fromLocation, to: toLocation)
        rideViewModel.createRide(from: fromLocation, to: toLocation, userId: userId)
    }
}

// MARK: - Address Input Panel
struct AddressInputPanel: View {
    @Binding var fromAddress: String
    @Binding var toAddress: String
    var onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(hex: "007AFF"))
                    .frame(width: 8, height: 8)
                
                TextField("Откуда", text: $fromAddress)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .cornerRadius(8)
            }
            
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                
                TextField("Куда", text: $toAddress)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .onTapGesture {
                        onSearch()
                    }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
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
            // Выбор типа авто
            HStack(spacing: 12) {
                ForEach(CarType.allCases, id: \.self) { carType in
                    Button(action: {
                        selectedCarType = carType
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: carType.icon)
                                .font(.title2)
                            
                            Text(carType.rawValue)
                                .font(.caption)
                            
                            Text("\(Int(carType.basePrice))₽")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedCarType == carType ? Color(hex: "007AFF").opacity(0.1) : Color.gray.opacity(0.1))
                        .foregroundColor(selectedCarType == carType ? Color(hex: "007AFF") : .gray)
                        .cornerRadius(12)
                    }
                }
            }
            
            // Информация о поездке
            if estimatedPrice > 0 {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Примерная стоимость")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(Int(estimatedPrice))₽")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Время в пути")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("~\(estimatedTime) мин")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Кнопка заказа
            Button(action: onOrder) {
                Text("Заказать такси")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "007AFF"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

