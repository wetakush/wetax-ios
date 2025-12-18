//
//  RideViewModel.swift
//  WeTax
//
//  ViewModel для управления поездками
//

import Foundation
import Combine
import CoreLocation

class RideViewModel: ObservableObject {
    @Published var currentRide: Ride?
    @Published var ridesHistory: [Ride] = []
    @Published var fromAddress: String = ""
    @Published var toAddress: String = ""
    @Published var selectedCarType: CarType = .economy
    @Published var estimatedPrice: Double = 0
    @Published var estimatedTime: Int = 0 // в минутах
    @Published var driver: Driver?
    @Published var isSearchingDriver = false
    
    private var cancellables = Set<AnyCancellable>()
    private var locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
        loadRideHistory()
    }
    
    func updateLocationService(_ service: LocationService) {
        self.locationService = service
    }
    
    func calculatePrice(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        // Расчет расстояния
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        let distance = fromLocation.distance(from: toLocation) / 1000.0 // в километрах
        
        // Расчет стоимости (базовая цена + цена за км)
        let pricePerKm = selectedCarType.basePrice * 0.1
        estimatedPrice = selectedCarType.basePrice + (distance * pricePerKm)
        
        // Расчет времени (примерно 2 минуты на км в городе)
        estimatedTime = Int(distance * 2)
    }
    
    func createRide(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, userId: String) {
        let fromLocation = LocationCoordinate(from: from)
        let toLocation = LocationCoordinate(from: to)
        
        let ride = Ride(
            userId: userId,
            fromAddress: fromAddress.isEmpty ? "Текущее местоположение" : fromAddress,
            toAddress: toAddress,
            fromLocation: fromLocation,
            toLocation: toLocation,
            carType: selectedCarType,
            price: estimatedPrice
        )
        
        currentRide = ride
        startSearchingDriver()
    }
    
    func startSearchingDriver() {
        guard currentRide != nil else { return }
        
        isSearchingDriver = true
        currentRide?.status = .searching
        
        // Симуляция поиска водителя
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.driverFound()
        }
    }
    
    func driverFound() {
        guard var ride = currentRide else { return }
        
        // Создаем мок-водителя
        let mockDriver = Driver(
            id: UUID().uuidString,
            name: "Александр Петров",
            phone: "+7 (999) 123-45-67",
            carModel: "Toyota Camry",
            carNumber: "А123БВ777",
            rating: 4.8,
            location: ride.fromLocation
        )
        
        driver = mockDriver
        ride.driverId = mockDriver.id
        ride.driverName = mockDriver.name
        ride.driverPhone = mockDriver.phone
        ride.status = .driverFound
        currentRide = ride
        
        // Симуляция прибытия водителя
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.driverArriving()
        }
    }
    
    func driverArriving() {
        guard var ride = currentRide else { return }
        ride.status = .driverArriving
        currentRide = ride
    }
    
    func startRide() {
        guard var ride = currentRide else { return }
        ride.status = .inProgress
        ride.startedAt = Date()
        currentRide = ride
    }
    
    func completeRide() {
        guard var ride = currentRide else { return }
        ride.status = .completed
        ride.completedAt = Date()
        
        // Добавляем в историю
        ridesHistory.insert(ride, at: 0)
        saveRideHistory()
        
        currentRide = nil
        driver = nil
        isSearchingDriver = false
    }
    
    func cancelRide() {
        guard var ride = currentRide else { return }
        ride.status = .cancelled
        ridesHistory.insert(ride, at: 0)
        saveRideHistory()
        
        currentRide = nil
        driver = nil
        isSearchingDriver = false
    }
    
    private func loadRideHistory() {
        // Загрузка истории из UserDefaults (в реальном приложении - из API)
        if let data = UserDefaults.standard.data(forKey: "ridesHistory"),
           let decoded = try? JSONDecoder().decode([Ride].self, from: data) {
            ridesHistory = decoded
        }
    }
    
    private func saveRideHistory() {
        if let encoded = try? JSONEncoder().encode(ridesHistory) {
            UserDefaults.standard.set(encoded, forKey: "ridesHistory")
        }
    }
}

