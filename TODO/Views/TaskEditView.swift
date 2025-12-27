import SwiftUI
import SwiftData

struct TaskEditView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	
	var task: TaskItem?
	
	@State private var title = ""
	@FocusState private var isTextFieldFocused: Bool
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Название задачи", text: $title)
						.focused($isTextFieldFocused)
				}
			}
			.navigationTitle(task == nil ? "Новая задача" : "Редактировать")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Отмена") {
						dismiss()
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Сохранить") {
						saveTask()
						dismiss()
					}
					.disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
				}
			}
			.onAppear {
				if let task = task {
					title = task.title
				}
				isTextFieldFocused = true
			}
		}
	}
	
	private func saveTask() {
		let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
		
		if let task = task {
			// Редактируем существующую задачу
			task.title = trimmedTitle
		} else {
			// Создаем новую задачу
			let newTask = TaskItem(title: trimmedTitle)
			modelContext.insert(newTask)
		}
		
		try? modelContext.save()
	}
}
