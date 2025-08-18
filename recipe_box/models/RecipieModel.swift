import SwiftData
import Foundation

@Model
class Recipe{
	init(id: UUID = UUID(), name: String, ingredients: [String], instructions: String, imageURL: String? = nil, sourceURL: String? = nil, tags: [String] = [], notes: String = "", rating: Int = 0, isFavorite: Bool = false, isArchived: Bool = false) {
		self.id = id
		self.name = name
		self.ingredients = ingredients
		self.instructions = instructions
		self.imageURL = imageURL
		self.sourceURL = sourceURL
		self.tags = tags
		self.notes = notes
		self.rating = rating
		self.isFavorite = isFavorite
		self.isArchived = isArchived
		self.createdAt = Date()
	}
	@Attribute(.unique) var id: UUID
	var name: String
	var ingredients: [String]
	var instructions: String
	var imageURL: String?
	var sourceURL: String?
	var createdAt: Date = Date()
	var tags: [String] = []
	var notes: String = ""
	var rating: Int = 0 // 0-5 scale
	var isFavorite: Bool = false
	var isArchived: Bool = false
	
}
