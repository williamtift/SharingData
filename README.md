# SharingData

Two simple iOS apps that demonstrate data sharing between applications. I put these together because I thought having both sides of the sharing flow in one place might be helpful for anyone looking to implement this functionality.

## 🎬 Demo

<img src="assets/demo.gif" alt="Data Sharing Demo" width="300">

*Sharing an image from OutputData to InputData, presenting a custom UI without leaving the current app*

## 📱 What's Here

**OutputData** - Shows how to share images from your app using ShareLink  
**InputData** - Shows how to receive shared images using Share Extensions

Having both apps lets you see the complete picture of how data flows between iOS applications. You can literally share from one to the other and watch it work.

## 📁 Project Structure

```
SharingData/
├── README.md
├── .gitignore
├── OutputData/                    # Sharing app
│   ├── OutputData/
│   │   ├── OutputDataApp.swift         # App entry point
│   │   ├── ContentView.swift           # ShareLink implementation
│   │   └── Assets.xcassets/
│   └── OutputData.xcodeproj
├── InputData/                     # Receiving app
│   ├── InputData/
│   │   ├── InputDataApp.swift          # App entry point
│   │   ├── ContentView.swift           # Main app placeholder UI
│   │   └── Assets.xcassets/
│   ├── ShareExtension/            # Share Extension target
│   │   ├── Info.plist                  # Extension configuration
│   │   ├── ShareViewController.swift   # UIKit entry point
│   │   └── ShareExtensionView.swift    # SwiftUI interface
│   └── InputData.xcodeproj
```

## 🎯 Why These Examples

ShareLink and Share Extensions are pretty straightforward once you see them in action, but it can be helpful to have working examples that you can actually run and test. The two apps complement each other well - you can share an image from OutputData and immediately see how InputData receives and processes it. OutputData has a simple share button, and InputData installs a Share Extension that appears in the system share sheet when sharing images specifically.

## 📋 Implementation Notes

**OutputData** 
- *ShareLink API*: Uses iOS 16's ShareLink component which replaces the need for the more complex `UIActivityViewController` approach used in earlier iOS versions:
```swift
ShareLink(item: image, preview: SharePreview("Title", image: image)) {
    // Your share button UI
}
```
- *Preview System*: `SharePreview` lets you customize how your content appears in the share sheet with a title and preview image.

**InputData**
- *Share Extension Architecture*: Share Extensions require a UIViewController as the entry point (`NSExtensionPrincipalClass`), which is why I didn't go all-in with SwiftUI from the beginning. The UIViewController then hosts the SwiftUI view for the actual interface.
- *File Format Configuration*: The Share Extension specifies which file types it accepts in `Info.plist`. In this case, I configured it to accept images using:
```xml
<key>NSExtensionActivationRule</key>
<string>SUBQUERY(extensionItems, $extensionItem, SUBQUERY($extensionItem.attachments, $attachment, ((ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO 'public.image') AND $extensionItem.attachments.@count &lt; 10)).@count == $extensionItem.attachments.@count).@count == 1</string>
```
- *Data Persistence*: This example only demonstrates receiving and displaying shared data. If you wanted to store images for later use in the InputData app, you'd need to handle persistence using App Groups to share data between the extension and the containing app - app extensions and containing app communication is a topic in itself.

## 🔄 Seeing It All Work

1. Build and run both apps
2. Open OutputData and tap the share button
3. You'll see "InputData" as an option in the share sheet
4. Tap it and watch how the image gets processed and displayed
5. The Share Extension handles everything automatically
