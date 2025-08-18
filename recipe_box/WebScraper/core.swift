import Foundation
import SwiftSoup
import SwiftData

actor WebScraperAgent{
	private let fetcher: Fetcher
	private let throttler: HostThrottler
	private let visited: Visited
	private let queue: CrawlQueue
	private let aiParser: AIParser
	
	init() async {
		self.fetcher = await Fetcher()
		self.throttler = await HostThrottler(delayMs: CONFIG.perHostDelayMs)
		self.visited = Visited()
		self.queue = CrawlQueue()
		self.aiParser = AIParser()
	}
	

	func scrape(url: String) -> String {
		return ""
	}
	
	func parseHTML(html: String) -> [String: Any] {
		return [:]
	}
	
	func crawl(url: String, depth: Int) -> [String] {
		return []
		
	}
	
}
