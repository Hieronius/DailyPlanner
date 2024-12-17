import Foundation
import RealmSwift

/// Protocol for implementation of the manager to work with Realm Data Storage
protocol RealmDataManagerProtocol: AnyObject {
	// func saveAllTasks(_ tasks: [ToDo])

	/// Get all stored tasks for specific day when we get to the main screen
//	func loadDailyTasks() -> [ToDo]
//
	/// Load only selected task
	func loadSelectedTask(id: UUID) -> ToDo?

	///	Save the task
	func saveTask(_ task: ToDo)

	/// Edit the task
//	func editTask(_ task: ToDo)
//
//	/// Remove selected task
//	func deleteTask(_ task: ToDo)
}

/// Implementation of the manager to work with Realm Data Storage
final class RealmDataManager: RealmDataManagerProtocol {

	// MARK: - Private Properties

	private let realm = try! Realm()

	// MARK: - Public Properties

//	func loadDailyTasks() -> [ToDo] {
//		<#code#>
//	}
//
	func loadSelectedTask(id: UUID) -> ToDo? {
		let realmTasks = realm.objects(ToDoRealm.self)
		// Fetching a single task by ID
		guard let selectedObject = realmTasks.first(where: { $0.id == id }) else { return nil }
		let selectedTask = ToDo(id: selectedObject.id,
								title: selectedObject.title,
								description: selectedObject.discription,
								startDate: selectedObject.startDate,
								endDate: selectedObject.endDate,
								isCompleted: selectedObject.isCompleted)
		return selectedTask
	}

	func saveTask(_ task: ToDo) {
		let realmTask = ToDoRealm(id: task.id,
								  title: task.title,
								  discription: task.description,
								  startDate: task.startDate,
								  endDate: task.endDate,
								  isCompleted: task.isCompleted)

		try! realm.write{
			realm.add(realmTask)
		}

	}

//	func editTask(_ task: ToDo) {
//
//	}
//
//	func deleteTask(_ task: ToDo) {
//		<#code#>
//	}



}
