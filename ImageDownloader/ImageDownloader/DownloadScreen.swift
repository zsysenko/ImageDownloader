//
//  ContentView.swift
//  ImageDownloader
//
//  Created by EVGENY SYSENKA on 23/05/2025.
//

import SwiftUI

struct DownloadScreen: View {
    @Environment(DownloadImageModel.self) private var model
    
    private var testURL = "https://picsum.photos/1200/1300"
    
    var body: some View {
        Spacer()
        
        if let image = model.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()
                .transition(.slide)
        }
        
        controlView
    }
    
    private var controlView: some View {
        VStack {
            Button {
                Task {
                    await model.fetchImage(from: testURL)
                }
            } label: {
                if model.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Download")
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
            }
            .buttonStyle(.borderedProminent)

            Button {
                Task {
//                    model.cancelDownload()
                }
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .tint(.gray)
            .buttonStyle(.borderedProminent)
            
            Button {
                Task {
                    await model.clearCache(for: testURL)
                }
            } label: {
                Text("Clear")
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    DownloadScreen()
        .environment(DownloadImageModel(apiService: ApiService()))
}
