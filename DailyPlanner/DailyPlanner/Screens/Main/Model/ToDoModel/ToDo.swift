import Foundation

/// Model to hold a `ToDo` properties 
struct ToDo: Hashable {
	var id: UUID
	var title: String = ""
	var description: String = ""
	var startDate: Date?
	var endDate: Date?
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
