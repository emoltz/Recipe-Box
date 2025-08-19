import Foundation

struct CrawlConfig {
	let concurrency: Int
	let perHostDelayMs: Int
	let maxDepth: Int
	let userAgent: String
	let timeoutSeconds: Double
	let followSameHostOnly: Bool
	let useAIParsing: Bool
	let openAIModel: String
}

let CONFIG = CrawlConfig(
	concurrency: Int(ProcessInfo.processInfo.environment["SCRAPER_CONCURRENCY"] ?? "8") ?? 8,
	perHostDelayMs: Int(ProcessInfo.processInfo.environment["SCRAPER_DELAY_MS"] ?? "400") ?? 400,
	maxDepth: Int(ProcessInfo.processInfo.environment["SCRAPER_MAX_DEPTH"] ?? "1") ?? 1,
	userAgent: ProcessInfo.processInfo.environment["SCRAPER_UA"] ?? "SwiftScraper/1.0 (+https://example.org)",
	timeoutSeconds: Double(ProcessInfo.processInfo.environment["SCRAPER_TIMEOUT"] ?? "20") ?? 20,
	followSameHostOnly: (ProcessInfo.processInfo.environment["SCRAPER_SAME_HOST"] ?? "true") == "true",
	useAIParsing: (ProcessInfo.processInfo.environment["SCRAPER_USE_AI"] ?? "false") == "true",
	openAIModel: ProcessInfo.processInfo.environment["OPENAI_MODEL"] ?? "gpt-5"
)

extension URL {
	var normalized: URL {
		var comps = URLComponents(url: self, resolvingAgainstBaseURL: false)
		comps?.fragment = nil
		return comps?.url ?? self
	}
	var hostOrEmpty: String { host ?? "" }
}
