import Foundation

/// Model to hold a `ToDo` properties for JSON representation
struct ToDoJSON: Codable {
	
	/// The unique identifier for the to-do item.
	var id: UUID

	/// The title of the to-do item.
	var title: String

	/// A description of the to-do item.
	var description: String

	/// The start date for the to-do item (optional).
	var startDate: Date?

	/// The end date for the to-do item (optional).
	var endDate: Date?

	/// A Boolean value indicating whether the to-do item is completed.
	var isCompleted: Bool

	// MARK: - Conversion from `ToDo`

	/// This initializer extracts properties from an existing `ToDo` object and assigns them
	/// to the corresponding properties of `ToDoJSON`.
	///
	/// - Parameter todo: The `ToDo` object from which to initialize the `ToDoJSON`.
	init(from todo: ToDo) {
		self.id = todo.id
		self.title = todo.title
		self.description = todo.description
		self.startDate = todo.startDate
		self.endDate = todo.endDate
		self.isCompleted = todo.isCompleted
	}
}
