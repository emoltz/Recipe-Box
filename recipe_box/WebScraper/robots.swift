import Foundation

actor Robots {
	private var cache: [String: Set<String>] = [:] // host -> disallowed prefixes
	
	
	func allowed(_ url: URL) async -> Bool {
		guard let host = url.host else { return true }
		if cache[host] == nil {
			cache[host] = await fetchRobots(for: host, scheme: url.scheme ?? "https")
		}
		let disallows = cache[host] ?? []
		let path = url.path
		for prefix in disallows { if path.hasPrefix(prefix) { return false } }
		return true
	}
	
	private func fetchRobots(for host: String, scheme: String) async -> Set<String> {
		guard let robotsURL = URL(string: "\(scheme)://\(host)/robots.txt") else { return [] }
		var req = URLRequest(url: robotsURL)
		req.setValue(CONFIG.userAgent, forHTTPHeaderField: "User-Agent")
		do {
			let (data, resp) = try await URLSession.shared.data(for: req)
			guard let http = resp as? HTTPURLResponse, http.statusCode < 400 else { return [] }
			let text = String(data: data, encoding: .utf8) ?? ""
			// naive parse: collect Disallow under User-agent: *
			var currentStar = false
			var disallows = Set<String>()
			for raw in text.split(separator: "\n") {
				let line = raw.trimmingCharacters(in: .whitespaces)
				if line.lowercased().hasPrefix("user-agent:") {
					currentStar = line.lowercased().contains("*")
				} else if currentStar && line.lowercased().hasPrefix("disallow:") {
					let v = line.dropFirst("disallow:".count)
						.trimmingCharacters(in: .whitespaces)
					if !v.isEmpty { disallows.insert(v) }
				}
			}
			return disallows
		} catch { return [] }
	}
}
