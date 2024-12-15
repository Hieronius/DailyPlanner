import Foundation

struct ToDo: Hashable {
	var id: UUID
	var title: String = "Title"
	var description: String = "Description"
	var startDate: Date?
	var endDate: Date?
	var isCompleted: Bool = false
}
