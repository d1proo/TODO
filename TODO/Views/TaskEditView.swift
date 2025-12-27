import SwiftUI
import SwiftData

struct EditTodoView: View {
	let todo: TodoItem
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	
	@State private var title = ""
	@State private var taskDescription = ""
	@FocusState private var focusedField: Field?
	
	enum Field {
		case title, taskDescription
	}
	
	var isValid: Bool {
		!title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
	
	init(todo: TodoItem) {
		self.todo = todo
		_title = State(initialValue: todo.title)
		_taskDescription = State(initialValue: todo.taskDescription ?? "")
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
			.navigationTitle("Изменить задачу")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Отмена") {
						dismiss()
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Сохранить") {
						todo.title = title
						todo.taskDescription = taskDescription.isEmpty ? nil : taskDescription
						try? modelContext.save()
						dismiss()
					}
					.disabled(!isValid)
				}
			}
			.onAppear {
				focusedField = .title
			}
		}
	}
}
