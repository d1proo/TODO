//
//  SwiftDataManager.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import Foundation
import SwiftData

final class SwiftDataManager {
	private let context: ModelContext
	
	init(context: ModelContext) {
		self.context = context
	}
	
	// MARK: - CRUD Operations
	
	func fetchTodos() -> [TodoItem] {
		let descriptor = FetchDescriptor<TodoItem>(
			sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
		)
		
		do {
			return try context.fetch(descriptor)
		} catch {
			print("Ошибка загрузки задач: \(error)")
			return []
		}
	}
	
	func addTodo(title: String, taskDescription: String?){
		let todo = TodoItem(title: title, taskDescription: taskDescription)
		context.insert(todo)
		saveContext()
	}
	
	func updateTodo(_ todo: TodoItem, title: String, taskDescription: String?) {
		todo.title = title
		todo.taskDescription = taskDescription
		saveContext()
	}
	
	func deleteTodo(_ todo: TodoItem) {
		context.delete(todo)
		saveContext()
	}
	
	func toggleTodo(_ todo: TodoItem) {
		todo.toggleCompletion()
		saveContext()
	}
	
	private func saveContext() {
		do {
			try context.save()
		} catch {
			print("Ошибка сохранения контекста: \(error)")
		}
	}
}
