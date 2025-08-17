import Foundation
import SwiftSoup

struct ParsedPage: Codable {
	var url: String
	var title: String
	var textPreview: String
	var links: [String]
	var ai: AIExtraction? // optional AI results
}

struct AIExtraction: Codable {
	var headline: String?
	var author: String?
	var published_at: String?
	var summary: String?
	var key_entities: [String]?
}

func parseHTML(url: URL, html: String) throws -> ParsedPage {
	let doc = try SwiftSoup.parse(html, url.absoluteString)
	let title = try doc.title()
	// crude main text: concatenate <p> contents
	let paragraphs = try doc.select("p").array().prefix(20).map { try $0.text() }
	let textPreview = paragraphs.joined(separator: " ").prefix(1500).description
	// collect absolute links
	let aTags = try doc.select("a[href]").array()
	let links = try aTags.compactMap { a -> String? in
		let href = try a.attr("abs:href")
		return href.isEmpty ? nil : href
	}
	return ParsedPage(url: url.absoluteString, title: title, textPreview: textPreview, links: Array(Set(links)))
}
