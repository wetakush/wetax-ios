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

struct Driver: Codable {
    let id: String
    var name: String
    var phone: String
    var carModel: String
    var carNumber: String
    var rating: Double
    var location: LocationCoordinate
}

