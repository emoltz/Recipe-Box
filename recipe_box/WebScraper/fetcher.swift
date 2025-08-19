import Foundation

struct FetchResult { let url: URL; let finalURL: URL; let html: String }

final class Fetcher {
	private let ua = CONFIG.userAgent
	private let timeout = CONFIG.timeoutSeconds
	
	func getHTML(_ url: URL, maxRetries: Int = 3) async throws -> FetchResult {
		var attempt = 0
		var current = url
		while true {
			do {
				var req = URLRequest(url: current, timeoutInterval: timeout)
				req.setValue(ua, forHTTPHeaderField: "User-Agent")
				req.setValue("text/html,application/xhtml+xml", forHTTPHeaderField: "Accept")
				let (data, resp) = try await URLSession.shared.data(for: req)
				guard let http = resp as? HTTPURLResponse else {
					throw URLError(.badServerResponse)
				}
				
				// Handle redirects
				if (300..<400).contains(http.statusCode) {
					guard let location = http.allHeaderFields["Location"] as? String,
						  let redirectURL = URL(string: location, relativeTo: current) else {
						throw URLError(.badURL)
					}
					current = redirectURL
					continue
				}
				
				guard (200..<300).contains(http.statusCode) else {
					throw URLError(.badServerResponse)
				}
				guard let html = String(data: data, encoding: .utf8)
						?? String(data: data, encoding: .isoLatin1) else {
					throw URLError(.cannotDecodeRawData)
				}
				return FetchResult(url: url, finalURL: http.url ?? current, html: html)
			} catch {
				attempt += 1
				if attempt > maxRetries { throw error }
				let backoffNs = UInt64(pow(2.0, Double(attempt))) * 200_000_000 // 0.2s, 0.4s, 0.8s...
				try? await Task.sleep(nanoseconds: backoffNs)
			}
		}
	}
}
