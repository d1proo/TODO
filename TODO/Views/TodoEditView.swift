//
//  TodoEditView.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import SwiftUI

struct TodoEditView: View {
	@Bindable var viewModel: TodoViewModel
	let todo: TodoItem?
	
	@Environment(\.dismiss) private var dismiss
	
	@State private var title = ""
	@State private var taskDescription = ""
	@FocusState private var focusedField: Field?
	
	enum Field {
		case title, taskDescription
	}
	
	var isEditing: Bool {
		todo != nil
	}
	
	var isValid: Bool {
		!title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
	
	init(viewModel: TodoViewModel, todo: TodoItem?) {
		self.viewModel = viewModel
		self.todo = todo
		
		if let todo = todo {
			_title = State(initialValue: todo.title)
			_taskDescription = State(initialValue: todo.taskDescription ?? "")
		}
	}
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Название задачи", text: $title)
						.focused($focusedField, equals: .title)
						.submitLabel(.next)
					
					TextField("Описание (необязательно)", text: $taskDescription, axis: .vertical)
						.focused($focusedField, equals: .taskDescription)
						.lineLimit(3...5)
				}
			}
			.navigationTitle(isEditing ? "Изменить задачу" : "Новая задача")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Отмена") {
						dismiss()
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(isEditing ? "Сохранить" : "Добавить") {
						if isEditing, let todo = todo {
							viewModel.updateTodo(todo,
											   title: title,
											   taskDescription: taskDescription.isEmpty ? nil : taskDescription)
						} else {
							viewModel.addTodo(title: title,
											taskDescription: taskDescription.isEmpty ? nil : taskDescription)
						}
						dismiss()
					}
					.disabled(!isValid)
				}
				
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					Button("Готово") {
						focusedField = nil
					}
				}
			}
			.onAppear {
				focusedField = .title
			}
			.onSubmit {
				switch focusedField {
				case .title:
					focusedField = .taskDescription
				default:
					focusedField = nil
				}
			}
		}
	}
}
