import Foundation
import SwiftSoup
import SwiftData

actor WebScraperAgent{
	private let fetcher: Fetcher
	private let throttler: HostThrottler
	private let visited: Visited
	private let queue: CrawlQueue
	private let aiParser: AIParser
	private let followSameHostOnly: Bool
	
	init() async {
		self.fetcher = await Fetcher()
		self.throttler = await HostThrottler(delayMs: CONFIG.perHostDelayMs)
		self.visited = Visited()
		self.queue = CrawlQueue()
		self.aiParser = AIParser()
		self.followSameHostOnly = await CONFIG.followSameHostOnly
	}
	

	func scrape(url: String) async throws -> String {
		guard let url = URL(string: url) else {
			throw URLError(.badURL)
		}
		
		// Throttle requests per host
		await throttler.waitTurn(for: url.host ?? "unknown")
		
		// Fetch HTML
		let fetchResult = try await fetcher.getHTML(url)
		
		// Parse HTML to structured data
		let parsedPage = try await parseHTML(url: fetchResult.finalURL, html: fetchResult.html)
		
		// Convert to JSON string
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		let jsonData = try encoder.encode(parsedPage)
		return String(data: jsonData, encoding: .utf8) ?? "{}"
	}
	
	
	func crawl(url: String, depth: Int) async throws -> [String] {
		guard let startURL = URL(string: url) else {
			throw URLError(.badURL)
		}
		
		// Reset state
		await queue.push(QueueItem(url: startURL, depth: 0))
		var results: [String] = []
		
		// Process queue with concurrency control
		await withTaskGroup(of: Void.self) { group in
			for _ in await 0..<CONFIG.concurrency {
				group.addTask {
					await self.processCrawlQueue(maxDepth: depth, results: &results)
				}
			}
		}
		
		return results
	}
	
	private func processCrawlQueue(maxDepth: Int, results: inout [String]) async {
		while let item = await queue.pop() {
			// Skip if beyond max depth
			guard item.depth <= maxDepth else { continue }
			
			// Skip if already visited
			guard await visited.insertIfNew(item.url) else { continue }
			
			do {
				// Scrape the page
				let pageJson = try await scrape(url: item.url.absoluteString)
				results.append(pageJson)
				
				// Add linked pages to queue if not at max depth
				if item.depth < maxDepth {
					let fetchResult = try await fetcher.getHTML(item.url)
					let parsedPage = try await parseHTML(url: item.url, html: fetchResult.html)
					
					for linkString in parsedPage.links.prefix(10) { // Limit links per page
						guard let linkURL = URL(string: linkString),
							  shouldFollowLink(from: item.url, to: linkURL) else { continue }
						
						await queue.push(QueueItem(url: linkURL, depth: item.depth + 1))
					}
				}
			} catch {
				print("Failed to crawl \(item.url): \(error)")
			}
		}
	}
	
	private func shouldFollowLink(from: URL, to: URL) -> Bool {
		// Only follow same-host links if configured
		if self.followSameHostOnly {
			return from.host == to.host
		}
		return true
	}
	
	// MARK: - Recipe-specific methods
	
	func convertToRecipe(_ parsedPage: ParsedPage) async -> Recipe  {
		// Extract ingredients from text (basic implementation)
		let ingredients = extractIngredients(from: parsedPage.textPreview)
		
		// Extract instructions (use full text for now)
		let instructions = parsedPage.textPreview
		
		// Create recipe with parsed data
		return await Recipe(
			name: parsedPage.title.isEmpty ? "Untitled Recipe" : parsedPage.title,
			ingredients: ingredients,
			instructions: instructions,
			sourceURL: parsedPage.url,
			tags: ["scraped", "web"]
		)
	}
	
	private func extractIngredients(from text: String) -> [String] {
		// Simple ingredient extraction (could be enhanced with AI)
		let lines = text.components(separatedBy: .newlines)
		return lines
			.filter { line in
				// Basic heuristics for ingredient lines
				let trimmed = line.trimmingCharacters(in: .whitespaces)
				return trimmed.count > 5 && 
					   (trimmed.contains("cup") || 
						trimmed.contains("tbsp") || 
						trimmed.contains("tsp") ||
						trimmed.contains("oz") ||
						trimmed.contains("lb") ||
						trimmed.contains("gram"))
			}
			.prefix(20) // Limit to 20 ingredients max
			.map { $0.trimmingCharacters(in: .whitespaces) }
	}
	
	// MARK: - Public interface for ContentView
	
	func crawlRecipeSites() async throws -> [Recipe] {
		var allRecipes: [Recipe] = []
		
		// Crawl a subset of popular recipe sites
		for siteURL in await RecipeSites.popular.prefix(3) { // Start with just 3 sites
			do {
				print("Crawling \(siteURL)...")
				let jsonResults = try await crawl(url: siteURL, depth: 1)
				
				// Convert JSON results to Recipe objects
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .iso8601
				
				for jsonString in jsonResults {
					if let jsonData = jsonString.data(using: .utf8),
					   let parsedPage = try? decoder.decode(ParsedPage.self, from: jsonData) {
						let recipe = await convertToRecipe(parsedPage)
						allRecipes.append(recipe)
					}
				}
				
				print("Found \(jsonResults.count) pages from \(siteURL)")
				
			} catch {
				print("Failed to crawl \(siteURL): \(error)")
				continue
			}
		}
		
		return allRecipes
	}
	
}
