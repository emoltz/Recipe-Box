import Foundation

actor Visited {
	private var set = Set<URL>()
	func insertIfNew(_ url: URL) -> Bool {
		if set.contains(url) { return false }
		set.insert(url); return true
	}
}

struct QueueItem { let url: URL; let depth: Int }

actor CrawlQueue {
	private var items = [QueueItem]()
	func push(_ item: QueueItem) { items.append(item) }
	func pop() -> QueueItem? { items.isEmpty ? nil : items.removeFirst() }
	func isEmpty() -> Bool { items.isEmpty }
}
