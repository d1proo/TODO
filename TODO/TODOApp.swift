//
//  TODOApp.swift
//  TODO
//
//  Created by Дмитрий Прохоренко on 27.12.2025.
//

import SwiftUI
import SwiftData

@main
struct TodoApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		// Передаем контейнер в окружение приложения
		.modelContainer(for: TodoItem.self)
	}
}
