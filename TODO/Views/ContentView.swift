import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var allTasks: [TaskItem]
	
	@State private var showingAddTask = false
	@State private var editingTask: TaskItem?
	
	// Разделяем задачи на активные и выполненные
	private var activeTasks: [TaskItem] {
		allTasks.filter { !$0.isCompleted }
			.sorted { $0.createdAt < $1.createdAt }
	}
	
	private var completedTasks: [TaskItem] {
		allTasks.filter { $0.isCompleted }
			.sorted { $0.createdAt < $1.createdAt }
	}
	
	var body: some View {
		NavigationStack {
			List {
				// Раздел активных задач
				if !activeTasks.isEmpty {
					Section("Активные задачи") {
						ForEach(activeTasks) { task in
							TaskRowView(
								task: task,
								onToggleComplete: { toggleTask(task) },
								onEdit: { editingTask = task }
							)
							.swipeActions {
								Button(role: .destructive) {
									deleteTask(task)
								} label: {
									Label("Удалить", systemImage: "trash")
								}
							}
						}
					}
				}
				
				// Раздел выполненных задач
				if !completedTasks.isEmpty {
					Section("Выполненные") {
						ForEach(completedTasks) { task in
							TaskRowView(
								task: task,
								onToggleComplete: { toggleTask(task) },
								onEdit: { editingTask = task }
							)
							.swipeActions {
								Button(role: .destructive) {
									deleteTask(task)
								} label: {
									Label("Удалить", systemImage: "trash")
								}
							}
							.listRowBackground(Color.gray.opacity(0.1))
						}
					}
				}
			}
			.animation(.spring(duration: 0.3), value: allTasks.map { $0.isCompleted })
			.navigationTitle("Задачи")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showingAddTask = true
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $showingAddTask) {
				TaskEditView()
			}
			.sheet(item: $editingTask) { task in
				TaskEditView(task: task)
			}
		}
	}
	
	private func toggleTask(_ task: TaskItem) {
		withAnimation(.spring(duration: 0.3)) {
			task.isCompleted.toggle()
			try? modelContext.save()
		}
	}
	
	private func deleteTask(_ task: TaskItem) {
		withAnimation(.easeInOut) {
			modelContext.delete(task)
			try? modelContext.save()
		}
	}
}

struct TaskRowView: View {
	let task: TaskItem
	let onToggleComplete: () -> Void
	let onEdit: () -> Void
	
	var body: some View {
		HStack {
			Button {
				onToggleComplete()
			} label: {
				Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
					.foregroundColor(task.isCompleted ? .green : .gray)
					.font(.title2)
			}
			.buttonStyle(.plain)
			
			Text(task.title)
				.strikethrough(task.isCompleted)
				.foregroundColor(task.isCompleted ? .gray : .primary)
				.onTapGesture {
					onEdit()
				}
			
			Spacer()
			
			// Показываем дату создания для старых задач
			if task.isCompleted {
				Text("\(formattedDate(task.createdAt))")
					.font(.caption)
					.foregroundColor(.gray)
			}
		}
		.padding(.vertical, 8)
		.transition(.move(edge: .leading).combined(with: .opacity))
	}
	
	private func formattedDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM"
		return formatter.string(from: date)
	}
}
