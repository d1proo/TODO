import Foundation
import SwiftData

@Model
class TaskItem {
	var title: String
	var isCompleted: Bool
	var createdAt: Date
	
	init(title: String, isCompleted: Bool = false) {
		self.title = title
		self.isCompleted = isCompleted
		self.createdAt = Date()
	}
}
