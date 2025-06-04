//
//  ContentView.swift
//  InputData
//

import SwiftUI

/// Main view for the InputData app
/// This is just a placeholder - the real functionality is in the Share Extension
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.and.arrow.down")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("InputData")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Share Extension Example")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("The real functionality is in the Share Extension!")
                    .font(.headline)
                
                Text("To test this app:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("1. Go to Photos app or OutputData app")
                    Text("2. Share an image")
                    Text("3. Look for 'InputData' in the share sheet")
                    Text("4. Tap it to see the extension in action")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}

/// Preview provider for SwiftUI canvas
#Preview {
    ContentView()
}
