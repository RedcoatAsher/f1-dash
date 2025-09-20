# tvOS URL Loader Boilerplate

A minimal SwiftUI tvOS application that wraps a configurable `WKWebView`. The app loads the URL defined in `AppConfig.swift`, so you can ship multiple white-label builds by changing a single value.

## Project structure

```
tvos-url-loader/
├── README.md
├── URLDash.xcodeproj
└── URLDash/
    ├── AppConfig.swift
    ├── ContentView.swift
    ├── Info.plist
    ├── URLDashApp.swift
    ├── WebView.swift
    ├── Assets.xcassets/
    │   └── Contents.json
    └── Preview Content/
        └── Preview Assets.xcassets/
            └── Contents.json
```

Open `URLDash.xcodeproj` in Xcode 15 or newer to build and run the project on tvOS.

## Configure the destination URL

The only place you need to update to ship a differently branded app is [`AppConfig.swift`](URLDash/AppConfig.swift):

```swift
static let urlString = "https://example.com"
```

Set the value to the fully-qualified URL you want to present. The helper computed property validates the value at launch and will crash in debug builds if the string is not a valid URL, making mistakes easier to spot early.

## Releasing multiple white-label builds

1. Duplicate the project directory for each brand or environment.
2. Update `urlString` in `AppConfig.swift` to point at the correct endpoint.
3. Optionally customise the bundle identifier in the *Signing & Capabilities* section of the target settings.
4. Provide brand-specific app icons and top shelf images by adding an `AppIcon.brandassets` catalog under `Assets.xcassets` before submitting to the App Store.

Because the rest of the application is generic, no other code changes are required to publish additional builds.

## Notes

- The deployment target is tvOS 17.0 (adjust in the target build settings if you need a different minimum version).
- The embedded web view enables inline media playback and sets a tvOS-friendly user agent string.
- Error and loading states are surfaced with simple SwiftUI overlays so viewers understand what is happening.
- If the target site requires non-HTTPS content, add the appropriate [App Transport Security exceptions](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity) to `Info.plist`.
