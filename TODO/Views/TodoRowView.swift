//
//  TodoRowView.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import SwiftUI

struct TodoRowView: View {
	let todo: TodoItem
	@Bindable var viewModel: TodoViewModel
	
	@State private var isTapped = false
	
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 4) {
				Text(todo.title)
					.font(.headline)
					.strikethrough(todo.isCompleted, color: .gray)
				
				if let taskDescription = todo.taskDescription, !taskDescription.isEmpty {
					Text(taskDescription)
						.font(.subheadline)
						.foregroundColor(.secondary)
						.strikethrough(todo.isCompleted, color: .gray)
				}
			}
			.foregroundColor(todo.isCompleted ? .gray : .primary)
			
			Spacer()
			
			if todo.isCompleted {
				Image(systemName: "checkmark.circle.fill")
					.foregroundColor(.green)
			}
		}
		.padding()
		.background(todo.isCompleted ? Color.gray.opacity(0.1) : Color.white)
		.cornerRadius(10)
		.shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
		.padding(.horizontal)
		.contentShape(Rectangle())
		.onTapGesture {
			withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
				viewModel.toggleTodo(todo)
				isTapped = true
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					isTapped = false
				}
			}
		}
		.scaleEffect(isTapped ? 0.95 : 1.0)
		.contextMenu {
			Button(action: {
				viewModel.editingTodo = todo
			}) {
				Label("Изменить", systemImage: "pencil")
			}
			
			Button(role: .destructive, action: {
				withAnimation {
					viewModel.deleteTodo(todo)
				}
			}) {
				Label("Удалить", systemImage: "trash")
			}
		}
	}
}
