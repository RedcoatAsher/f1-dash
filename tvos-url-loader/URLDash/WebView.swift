import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let reloadID: UUID
    @Binding var isLoading: Bool
    @Binding var error: WebError?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        context.coordinator.configure(webView)
        context.coordinator.load(url, on: webView, reloadID: reloadID)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.parent = self
        if context.coordinator.lastLoadedURL != url || context.coordinator.lastReloadID != reloadID {
            context.coordinator.load(url, on: uiView, reloadID: reloadID)
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var lastLoadedURL: URL?
        var lastReloadID: UUID?

        init(parent: WebView) {
            self.parent = parent
        }

        func configure(_ webView: WKWebView) {
            webView.navigationDelegate = self
            webView.allowsBackForwardNavigationGestures = false
            webView.scrollView.contentInsetAdjustmentBehavior = .never
            webView.scrollView.bounces = false
            webView.isOpaque = false
            webView.backgroundColor = .black
            webView.scrollView.backgroundColor = .black
        }

        func load(_ url: URL, on webView: WKWebView, reloadID: UUID) {
            lastLoadedURL = url
            lastReloadID = reloadID

            var request = URLRequest(url: url)
            request.cachePolicy = .reloadRevalidatingCacheData
            request.setValue(Self.userAgent, forHTTPHeaderField: "User-Agent")

            parent.error = nil
            parent.isLoading = true
            webView.load(request)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            handle(error)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            handle(error)
        }

        private func handle(_ error: Error) {
            parent.isLoading = false
            parent.error = WebView.WebError(error: error)
        }

        private static let userAgent = "Mozilla/5.0 (AppleTV; U; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
    }

    struct WebError: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let message: String

        init(title: String = "Unable to Load", message: String) {
            self.title = title
            self.message = message
        }

        init(error: Error) {
            self.init(message: error.localizedDescription)
        }
    }
}
