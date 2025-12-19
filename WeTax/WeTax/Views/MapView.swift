//
//  MapView.swift
//  WeTax
//
//  Кастомная карта с маркерами
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var fromLocation: CLLocationCoordinate2D?
    var toLocation: CLLocationCoordinate2D?
    var driverLocation: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        
        // Удаляем старые аннотации
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        // Добавляем маркер отправления
        if let fromLocation = fromLocation {
            let fromAnnotation = MKPointAnnotation()
            fromAnnotation.coordinate = fromLocation
            fromAnnotation.title = "Откуда"
            mapView.addAnnotation(fromAnnotation)
        }
        
        // Добавляем маркер назначения
        if let toLocation = toLocation {
            let toAnnotation = MKPointAnnotation()
            toAnnotation.coordinate = toLocation
            toAnnotation.title = "Куда"
            mapView.addAnnotation(toAnnotation)
            
            // Рисуем маршрут
            if let fromLocation = fromLocation {
                drawRoute(from: fromLocation, to: toLocation, on: mapView)
            }
        }
        
        // Добавляем маркер водителя
        if let driverLocation = driverLocation {
            let driverAnnotation = MKPointAnnotation()
            driverAnnotation.coordinate = driverLocation
            driverAnnotation.title = "Водитель"
            mapView.addAnnotation(driverAnnotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, on mapView: MKMapView) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(hex: "007AFF")
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "CustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            // Кастомные иконки для разных типов маркеров
            if annotation.title == "Откуда" {
                annotationView?.image = UIImage(systemName: "mappin.circle.fill")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            } else if annotation.title == "Куда" {
                annotationView?.image = UIImage(systemName: "mappin.circle.fill")?
                    .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            } else if annotation.title == "Водитель" {
                annotationView?.image = UIImage(systemName: "car.fill")?
                    .withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            }
            
            return annotationView
        }
    }
}

