//
//  ContentView.swift
//  OutputData
//

import SwiftUI
import UIKit

/// Main view that demonstrates how to share data using ShareLink
/// Features a simple UI with a share button that allows sharing images to other apps
struct ContentView: View {
    // Example image to share - using SF Symbols for simplicity
    let example = Image(uiImage: UIImage(systemName: "airplane")!)
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("OutputData")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("ShareLink Example")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Share images to other apps using ShareLink!")
                    .font(.headline)
                
                Text("How to use this app:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("1. Tap the share button below")
                    Text("2. Select any compatible app from the share sheet")
                    Text("3. Try sharing to InputData to see the complete flow")
                    Text("4. Watch how the image appears in the receiving app")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // ShareLink - iOS 16+ component for native sharing
            // The 'item' parameter contains what to share
            // The 'preview' provides title and image for the share sheet
            ShareLink(item: example,
                      preview: SharePreview("Sample Image", image: example)) {
                Label("Click to share", systemImage: "airplane")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text("Try sharing to the InputData app!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

/// Preview provider for SwiftUI canvas
#Preview {
    ContentView()
}

