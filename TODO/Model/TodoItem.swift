//
//  TodoItem.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import Foundation
import SwiftData

@Model
class TodoItem: Identifiable {
	var id: UUID
	var title: String
	@Attribute(originalName: "taskDescription") var taskDescription: String?
	var isCompleted: Bool
	var createdAt: Date
	var completedAt: Date?
	
	init(title: String, taskDescription: String? = nil) {
		self.id = UUID()
		self.title = title
		self.taskDescription = taskDescription
		self.isCompleted = false
		self.createdAt = Date()
		self.completedAt = nil
	}
	
	func toggleCompletion() {
		isCompleted.toggle()
		completedAt = isCompleted ? Date() : nil
	}
}
