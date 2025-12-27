//
//  MainTodoView.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import SwiftUI

struct MainTodoView: View {
	@Bindable var viewModel: TodoViewModel
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					// Предстоящие задачи
					if !viewModel.upcomingTodos.isEmpty {
						VStack(alignment: .leading, spacing: 8) {
							Text("Предстоящие")
								.font(.title2)
								.fontWeight(.bold)
								.padding(.horizontal)
							
							ForEach(viewModel.upcomingTodos) { todo in
								TodoRowView(todo: todo, viewModel: viewModel)
							}
						}
					}
					
					// Завершенные задачи
					if !viewModel.completedTodos.isEmpty {
						VStack(alignment: .leading, spacing: 8) {
							Text("Завершенные")
								.font(.title2)
								.fontWeight(.bold)
								.foregroundColor(.secondary)
								.padding(.horizontal)
							
							ForEach(viewModel.completedTodos) { todo in
								TodoRowView(todo: todo, viewModel: viewModel)
							}
						}
					}
					
					// Пустой экран
					if viewModel.allTodos.isEmpty {
						VStack(spacing: 20) {
							Image(systemName: "checklist")
								.font(.system(size: 60))
								.foregroundColor(.gray)
							
							Text("Нет задач")
								.font(.title2)
								.foregroundColor(.gray)
							
							Text("Нажмите + чтобы добавить новую задачу")
								.font(.body)
								.foregroundColor(.gray)
								.multilineTextAlignment(.center)
						}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.padding(.top, 100)
					}
				}
				.padding(.vertical)
			}
			.navigationTitle("Мои задачи")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						viewModel.showingAddTodo = true
					}) {
						Image(systemName: "plus")
							.font(.headline)
					}
				}
			}
			.sheet(isPresented: $viewModel.showingAddTodo) {
				TodoEditView(viewModel: viewModel, todo: nil)
			}
			.sheet(item: $viewModel.editingTodo) { todo in
				TodoEditView(viewModel: viewModel, todo: todo)
			}
			.animation(.easeInOut, value: viewModel.allTodos)
		}
	}
}
