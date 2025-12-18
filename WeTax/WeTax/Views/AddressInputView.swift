//
//  AddressInputView.swift
//  WeTax
//
//  Экран ввода адресов
//

import SwiftUI
import MapKit

struct AddressInputView: View {
    @Binding var fromAddress: String
    @Binding var toAddress: String
    @ObservedObject var locationService: LocationService
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Поле поиска
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Поиск адреса", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            searchAddresses(query: newValue)
                        }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding()
                
                // Результаты поиска
                List(searchResults, id: \.self) { item in
                    Button(action: {
                        selectAddress(item: item)
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name ?? "")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            if let address = item.placemark.title {
                                Text(address)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Выбор адреса")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func searchAddresses(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(
            center: locationService.currentLocation ?? CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else { return }
            DispatchQueue.main.async {
                searchResults = response.mapItems
            }
        }
    }
    
    private func selectAddress(item: MKMapItem) {
        let address = item.name ?? item.placemark.title ?? ""
        
        if toAddress.isEmpty {
            toAddress = address
        } else {
            fromAddress = address
        }
        
        dismiss()
    }
}

