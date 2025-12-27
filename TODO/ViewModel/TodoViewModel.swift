//
//  ViewModel.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
@Observable
final class TodoViewModel {
	// Состояние UI
	var showingAddTodo = false
	var editingTodo: TodoItem?
	
	// Данные
	var allTodos: [TodoItem] = []
	
	// Зависимости
	private let dataManager: SwiftDataManager
	
	// Инициализация с менеджером данных
	init(dataManager: SwiftDataManager) {
		self.dataManager = dataManager
		loadTodos()
	}
	
	// MARK: - Public Methods
	
	func loadTodos() {
		allTodos = dataManager.fetchTodos()
	}
	
	func addTodo(title: String, taskDescription: String?) {
		dataManager.addTodo(title: title, taskDescription: taskDescription)
		loadTodos()
	}
	
	func updateTodo(_ todo: TodoItem, title: String, taskDescription: String?) {
		dataManager.updateTodo(todo, title: title, taskDescription: taskDescription)
		loadTodos()
	}
	
	func deleteTodo(_ todo: TodoItem) {
		dataManager.deleteTodo(todo)
		loadTodos()
	}
	
	func toggleTodo(_ todo: TodoItem) {
		dataManager.toggleTodo(todo)
		loadTodos()
	}
	
	// MARK: - Computed Properties
	
	var upcomingTodos: [TodoItem] {
		allTodos.filter { !$0.isCompleted }
	}
	
	var completedTodos: [TodoItem] {
		allTodos.filter { $0.isCompleted }
	}
}
