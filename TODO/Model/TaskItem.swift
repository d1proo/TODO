import Foundation
import SwiftData

@Model
final class TodoItem: Identifiable {
	var id: UUID
	var title: String
	var notes: String?
	var isCompleted: Bool
	var createdAt: Date
	
	init(title: String, notes: String? = nil) {
		self.id = UUID()
		self.title = title
		self.notes = notes
		self.isCompleted = false
		self.createdAt = Date()
	}
	
	func toggleCompletion() {
		isCompleted.toggle()
	}
}
