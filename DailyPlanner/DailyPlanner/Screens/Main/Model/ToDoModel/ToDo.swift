import Foundation

/// Model to hold a `ToDo` properties 
struct ToDo: Hashable {

	/// Unique `ToDo`s Identifier
	var id: UUID

	/// `ToDo` title
	var title: String = ""

	/// `ToDo` description
	var description: String = ""

	/// Designated time to start `ToDo`
	var startDate: Date?

	/// Designated time to end `ToDo`
	var endDate: Date?

	/// Property to monitor is `ToDo` been completed or not
	var isCompleted: Bool = false
}

// MARK: - Convertion from `ToDoRealm`

extension ToDo {
	
	init(object: ToDoRealm) {
		id = object.id
		title = object.title
		description = object.discription
		startDate = object.startDate
		endDate = object.endDate
		isCompleted = object.isCompleted
	}
}

// MARK: - Convertion from `ToDoJSON`

extension ToDo {

	init(json: ToDoJSON) {
		id = json.id
		title = json.title
		description = json.description
		startDate = json.startDate
		endDate = json.endDate
		isCompleted = json.isCompleted
	}
}
