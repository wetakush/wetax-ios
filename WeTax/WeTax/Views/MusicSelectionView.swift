//
//  MusicSelectionView.swift
//  WeTax
//
//  Экран выбора музыки для бизнеса
//

import SwiftUI
import AVFoundation

struct MusicSelectionView: View {
    @State private var selectedMusic: String? = nil
    @State private var isPlaying = false
    @Environment(\.dismiss) var dismiss
    
    let musicOptions = [
        ("Классика", "music.note"),
        ("Джаз", "music.note.list"),
        ("Поп", "music.mic"),
        ("Рок", "guitars.fill"),
        ("Тишина", "speaker.slash.fill")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Выберите музыку")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    ForEach(musicOptions, id: \.0) { music in
                        Button(action: {
                            selectedMusic = music.0
                            isPlaying = music.0 != "Тишина"
                        }) {
                            HStack {
                                Image(systemName: music.1)
                                    .foregroundColor(selectedMusic == music.0 ? Color(hex: "007AFF") : .gray)
                                    .font(.title3)
                                
                                Text(music.0)
                                    .font(.headline)
                                    .foregroundColor(selectedMusic == music.0 ? Color(hex: "007AFF") : .black)
                                
                                Spacer()
                                
                                if selectedMusic == music.0 && isPlaying {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "007AFF"))
                                }
                            }
                            .padding()
                            .background(selectedMusic == music.0 ? Color(hex: "007AFF").opacity(0.1) : Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedMusic == music.0 ? Color(hex: "007AFF") : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Музыка")
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
}

