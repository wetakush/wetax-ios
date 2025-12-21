//
//  Ride.swift
//  WeTax
//
//  Модель поездки
//

import Foundation
import CoreLocation

enum RideStatus: String, Codable {
    case searching = "Поиск водителя"
    case driverFound = "Водитель найден"
    case driverArriving = "Водитель едет"
    case inProgress = "В пути"
    case completed = "Завершена"
    case cancelled = "Отменена"
}

enum CarType: String, Codable, CaseIterable {
    case economy = "Эконом"
    case comfort = "Комфорт"
    case business = "Бизнес"
    
    var icon: String {
        switch self {
        case .economy: return "car.fill"
        case .comfort: return "car.2.fill"
        case .business: return "car.rear.fill"
        }
    }
    
    var basePrice: Double {
        switch self {
        case .economy: return 50.0
        case .comfort: return 80.0
        case .business: return 120.0
        }
    }
    
    var pricePerKm: Double {
        switch self {
        case .economy: return 15.0
        case .comfort: return 25.0
        case .business: return 40.0
        }
    }
}

struct Ride: Codable, Identifiable {
    let id: String
    var userId: String
    var fromAddress: String
    var toAddress: String
    var fromLocation: LocationCoordinate
    var toLocation: LocationCoordinate
    var carType: CarType
    var status: RideStatus
    var price: Double
    var driverId: String?
    var driverName: String?
    var driverPhone: String?
    var driverLocation: LocationCoordinate?
    var createdAt: Date
    var startedAt: Date?
    var completedAt: Date?
    
    init(
        id: String = UUID().uuidString,
        userId: String,
        fromAddress: String,
        toAddress: String,
        fromLocation: LocationCoordinate,
        toLocation: LocationCoordinate,
        carType: CarType,
        price: Double
    ) {
        self.id = id
        self.userId = userId
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.carType = carType
        self.status = .searching
        self.price = price
        self.createdAt = Date()
    }
}

struct LocationCoordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from clLocation: CLLocationCoordinate2D) {
        self.latitude = clLocation.latitude
        self.longitude = clLocation.longitude
    }
}

struct Driver: Codable, Identifiable {
    let id: String
    var name: String
    var phone: String
    var carModel: String
    var carNumber: String
    var rating: Double
    var location: LocationCoordinate
    
    static let economyDrivers: [Driver] = [
        Driver(id: "1", name: "Иван Смирнов", phone: "+7 (999) 111-22-33", carModel: "Renault Logan", carNumber: "А123БВ777", rating: 4.8, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "2", name: "Петр Иванов", phone: "+7 (999) 222-33-44", carModel: "Lada Granta", carNumber: "В456ГД888", rating: 4.6, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "3", name: "Сергей Петров", phone: "+7 (999) 333-44-55", carModel: "Hyundai Solaris", carNumber: "С789ЕЖ999", rating: 4.9, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "4", name: "Алексей Козлов", phone: "+7 (999) 444-55-66", carModel: "Kia Rio", carNumber: "Д012ЖЗ000", rating: 4.7, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173))
    ]
    
    static let comfortDrivers: [Driver] = [
        Driver(id: "5", name: "Дмитрий Волков", phone: "+7 (999) 555-66-77", carModel: "Haval Jolion", carNumber: "Е345ЗИ111", rating: 4.9, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "6", name: "Андрей Соколов", phone: "+7 (999) 666-77-88", carModel: "Kaiyi E5", carNumber: "Ж678ИК222", rating: 4.8, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "7", name: "Максим Лебедев", phone: "+7 (999) 777-88-99", carModel: "Toyota Camry", carNumber: "К901ЛМ333", rating: 5.0, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "8", name: "Николай Новиков", phone: "+7 (999) 888-99-00", carModel: "Skoda Octavia", carNumber: "Л234МН444", rating: 4.7, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173))
    ]
    
    static let businessDrivers: [Driver] = [
        Driver(id: "9", name: "Владимир Орлов", phone: "+7 (999) 999-00-11", carModel: "Maybach S-Class", carNumber: "М567НО555", rating: 5.0, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "10", name: "Александр Морозов", phone: "+7 (999) 000-11-22", carModel: "BMW F90 M5", carNumber: "Н890ОП666", rating: 5.0, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "11", name: "Роман Павлов", phone: "+7 (999) 111-22-33", carModel: "Mercedes S-Class", carNumber: "О123ПР777", rating: 4.9, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173)),
        Driver(id: "12", name: "Игорь Семенов", phone: "+7 (999) 222-33-44", carModel: "Audi A8", carNumber: "П456РС888", rating: 4.8, location: LocationCoordinate(latitude: 55.7558, longitude: 37.6173))
    ]
    
    static func getAvailableCars(for carType: CarType) -> [String] {
        switch carType {
        case .economy:
            return Array(Set(economyDrivers.map { $0.carModel }))
        case .comfort:
            return Array(Set(comfortDrivers.map { $0.carModel }))
        case .business:
            return Array(Set(businessDrivers.map { $0.carModel }))
        }
    }
    
    static func getDrivers(for carType: CarType) -> [Driver] {
        switch carType {
        case .economy:
            return economyDrivers
        case .comfort:
            return comfortDrivers
        case .business:
            return businessDrivers
        }
    }
    
    static func getRandomDriver(for carType: CarType) -> Driver {
        let drivers = getDrivers(for: carType)
        return drivers.randomElement() ?? drivers[0]
    }
    
    static func getDriver(for carType: CarType, carModel: String) -> Driver? {
        let drivers = getDrivers(for: carType)
        return drivers.first { $0.carModel == carModel }
    }
}

