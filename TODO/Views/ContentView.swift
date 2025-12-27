//
//  ContentView.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	// Получаем контекст из окружения SwiftData
	@Environment(\.modelContext) private var modelContext
	
	// Создаем ViewModel с контекстом
	@State private var viewModel: TodoViewModel?
	
	var body: some View {
		Group {
			if let viewModel = viewModel {
				MainTodoView(viewModel: viewModel)
			} else {
				ProgressView("Загрузка...")
			}
		}
		.onAppear {
			// Создаем ViewModel когда появляется view
			if viewModel == nil {
				// 1. Создаем SwiftDataManager с контекстом
				let dataManager = SwiftDataManager(context: modelContext)
				// 2. Создаем TodoViewModel с менеджером
				viewModel = TodoViewModel(dataManager: dataManager)
			}
		}
	}
}
