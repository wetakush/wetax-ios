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
    @Published var availableCars: [String] = []
    @Published var availableDrivers: [Driver] = []
    @Published var selectedCarModel: String? = nil
    @Published var showCarSelection = false
    @Published var showMusicSelection = false
    
    private var cancellables = Set<AnyCancellable>()
    private var locationService: LocationService
    private let telegramService = TelegramService()
    
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
        
        // Расчет стоимости (базовая цена + цена за км в зависимости от тарифа)
        let pricePerKm = selectedCarType.pricePerKm
        estimatedPrice = selectedCarType.basePrice + (distance * pricePerKm)
        
        // Расчет времени (примерно 2 минуты на км в городе)
        estimatedTime = max(5, Int(distance * 2))
    }
    
    func createRide(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, userId: String, userName: String, userPhone: String) {
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
        
        // Отправляем уведомление в Telegram
        telegramService.sendRideNotification(ride: ride, userName: userName, userPhone: userPhone)
        
        startSearchingDriver()
    }
    
    func startSearchingDriver() {
        guard let ride = currentRide else { return }
        
        isSearchingDriver = true
        currentRide?.status = .searching
        
        // Получаем доступных водителей для типа авто
        availableDrivers = Driver.getDrivers(for: ride.carType)
        availableCars = Driver.getAvailableCars(for: ride.carType)
        
        // Для бизнеса показываем выбор машины
        if ride.carType == .business {
            showCarSelection = true
            return
        }
        
        // Показываем доступные машины через 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            // Продолжаем поиск
        }
        
        // Симуляция поиска водителя
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.driverFound()
        }
    }
    
    func selectCarAndDriver(carModel: String) {
        selectedCarModel = carModel
        showCarSelection = false
        
        // Находим водителя с выбранной машиной
        if let selectedDriver = Driver.getDriver(for: selectedCarType, carModel: carModel) {
            driver = selectedDriver
            if var ride = currentRide {
                ride.driverId = selectedDriver.id
                ride.driverName = selectedDriver.name
                ride.driverPhone = selectedDriver.phone
                ride.status = .driverFound
                currentRide = ride
            }
            
            // Симуляция прибытия водителя
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.driverArriving()
            }
        }
    }
    
    func driverFound() {
        guard var ride = currentRide else { return }
        
        // Выбираем случайного водителя для типа авто
        let selectedDriver = Driver.getRandomDriver(for: ride.carType)
        
        driver = selectedDriver
        ride.driverId = selectedDriver.id
        ride.driverName = selectedDriver.name
        ride.driverPhone = selectedDriver.phone
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
        
        // Автоматически переключаемся на "В пути" через несколько секунд
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.startRide()
        }
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

