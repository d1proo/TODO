import SwiftUI
import SwiftData

@main
struct ToDoApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(for: TaskItem.self)
	}
}
