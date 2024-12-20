import Foundation

/// Model to hold a `ToDo` properties for JSON representation
struct ToDoJSON: Codable {
	var id: UUID
	var title: String
	var description: String
	var startDate: Date?
	var endDate: Date?
	var isCompleted: Bool

	// MARK: - Conversion from `ToDo`

	init(from todo: ToDo) {
		self.id = todo.id
		self.title = todo.title
		self.description = todo.description
		self.startDate = todo.startDate
		self.endDate = todo.endDate
		self.isCompleted = todo.isCompleted
	}
}
