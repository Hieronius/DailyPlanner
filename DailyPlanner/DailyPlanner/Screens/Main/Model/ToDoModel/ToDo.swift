import Foundation

struct ToDo: Hashable {
	var id: Int = 0
	var title: String = "Title"
	var description: String = "Description"
	var startDate: String = "Today"
	var endDate: String = "Tomorrow"
	var isCompleted: Bool = false
}
