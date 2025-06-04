//
//  ShareViewController.swift
//  ShareExtension
//

import SwiftUI
import UniformTypeIdentifiers

/// Share Extension View Controller
/// Simple controller that sets up SwiftUI view and handles extension lifecycle
class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the SwiftUI view with the extension item
        setupSwiftUIView(with: extensionContext?.inputItems.first as? NSExtensionItem)
    }
    
    /// Set up the SwiftUI view with the extension item
    /// - Parameter extensionItem: The shared content from other apps
    private func setupSwiftUIView(with extensionItem: NSExtensionItem?) {
        let contentView = UIHostingController(
            rootView: ShareExtensionView(
              extensionItem: extensionItem,
                onClose: { [weak self] in
                    self?.close()
                }
            )
        )
        
        // Add the SwiftUI view as a child view controller
        addChild(contentView)
        view.addSubview(contentView.view)
        
        // Set up Auto Layout constraints to fill the entire view
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        contentView.didMove(toParent: self)
    }
    
    /// Close the Share Extension and return to the sharing app
    private func close() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
