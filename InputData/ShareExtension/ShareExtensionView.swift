//
//  ShareExtensionView.swift
//  ShareExtension
//

import SwiftUI
import UniformTypeIdentifiers

/// SwiftUI view for displaying shared images in the Share Extension
/// Manages its own state and processes the NSExtensionItem to extract images
struct ShareExtensionView: View {
    @State private var images: [UIImage] = []
    @State private var isLoading: Bool = true
    
    private let extensionItem: NSExtensionItem?
    private var onClose: () -> Void
    
    /// Initialize the view with extension item
    /// - Parameters:
    ///   - extensionItem: The shared content from other apps
    ///   - onClose: Callback to close the Share Extension
    init(extensionItem: NSExtensionItem?, onClose: @escaping () -> Void) {
        self.extensionItem = extensionItem
        self.onClose = onClose
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if isLoading {
                    loadingView
                } else {
                    contentView
                }
            }
            .padding(.vertical)
            .navigationTitle("Share Extension")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await loadImages()
        }
    }
    
    /// Load shared images from the extension item using async/await
    private func loadImages() async {
        // Define the type of data we're looking for (file URLs that contain images)
        let imageDataType = UTType.fileURL.identifier
        var loadedImages = [UIImage]()

        // Process each attachment in the shared content
        if let attachments = extensionItem?.attachments {
            // Use async let to process multiple attachments concurrently
            await withTaskGroup(of: UIImage?.self) { group in
                for itemProvider in attachments {
                    // Check if this attachment contains the type of data we want
                    if itemProvider.hasItemConformingToTypeIdentifier(imageDataType) {
                        group.addTask {
                            do {
                                // Load the actual data from the item provider using async version
                                let providedData = try await itemProvider.loadItem(forTypeIdentifier: imageDataType)
                                
                                // Try to convert the provided data to an image
                                if let url = providedData as? URL,
                                   let imageData = try? Data(contentsOf: url),
                                   let image = UIImage(data: imageData) {
                                    return image
                                }
                            } catch {
                                print("Error loading item: \(error)")
                            }
                            return nil
                        }
                    }
                }
                
                // Collect all successfully loaded images
                for await result in group {
                    if let image = result {
                        loadedImages.append(image)
                    }
                }
            }
        }

        // Update the state on the main actor
        await MainActor.run {
            self.isLoading = false
            self.images = loadedImages
        }
    }
}

// MARK: UI
private extension ShareExtensionView {
    /// Loading state view
    var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading shared images...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Content state view with images
    var contentView: some View {
        VStack(spacing: 20) {
            headerView
            imageGallery
            doneButton
        }
    }
    
    /// Header information view
    var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            Text("Received \(images.count) image\(images.count == 1 ? "" : "s")")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    /// Scrollable image gallery view
    var imageGallery: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<images.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Text("Image \(index + 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// Action buttons view
    var doneButton: some View {
        Button {
            onClose()
        } label: {
            Text("Done")
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
