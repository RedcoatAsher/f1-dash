import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var error: WebView.WebError?
    @State private var reloadToken = UUID()

    var body: some View {
        ZStack {
            WebView(url: AppConfig.appURL, reloadID: reloadToken, isLoading: $isLoading, error: $error)
                .opacity(error == nil ? 1 : 0.2)
                .background(Color.black)

            if isLoading {
                ProgressView("Loading…")
                    .progressViewStyle(.circular)
                    .padding(32)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .transition(.opacity)
            }

            if let error {
                VStack(spacing: 24) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 96, weight: .regular))
                    Text(error.title)
                        .font(.title2).bold()
                    Text(error.message)
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .frame(maxWidth: 600)
                    Button("Retry") {
                        isLoading = true
                        self.error = nil
                        reloadToken = UUID()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40, style: .continuous))
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: error?.id)
    }
}

#Preview {
    ContentView()
}
