import Foundation
import RealmSwift

/// Protocol for implementation of the manager to work with Realm Data Storage
protocol RealmDataManagerProtocol: AnyObject {

	/// Get all stored tasks for specific day
	func loadDailyTasks(date: Date) -> [ToDo]

	/// Load only selected task
	func loadSelectedTask(id: UUID) -> ToDo?

	///	Save a new task
	func saveTask(_ task: ToDo)

	/// Make changes with selected task and update in Realm
	func editTask(_ task: ToDo)

	/// Remove selected task
	func deleteTask(_ task: ToDo)
}

/// Implementation of the manager to work with Realm Data Storage
final class RealmDataManager: RealmDataManagerProtocol {

	// MARK: - Private Properties

	private let realm = try! Realm()

	// MARK: - Public Properties

	/// Get all stored tasks for specific day
	func loadDailyTasks(date: Date) -> [ToDo] {

		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

		// Create a predicate that matches tasks with the specified year, month, and day
		let predicate = NSPredicate(format: "year(startDate) == %d AND month(startDate) == %d AND day(startDate) == %d",
									dateComponents.year!,
									dateComponents.month!,
									dateComponents.day!)

		let realmTasks = realm.objects(ToDoRealm.self).filter(predicate)

		let tasks: [ToDo] = realmTasks.map { realmTask in

			return ToDo(id: realmTask.id,
						title: realmTask.title,
						description: realmTask.description,
						startDate: realmTask.startDate,
						endDate: realmTask.endDate,
						isCompleted: realmTask.isCompleted)
		}

		return tasks
	}

	/// Load only selected task
	func loadSelectedTask(id: UUID) -> ToDo? {

		guard let realmTask = realm.object(ofType: ToDoRealm.self,
												forPrimaryKey: id)
		else { return nil }

		let task = ToDo(id: realmTask.id,
								title: realmTask.title,
								description: realmTask.discription,
								startDate: realmTask.startDate,
								endDate: realmTask.endDate,
								isCompleted: realmTask.isCompleted)
		return task
	}

	///	Save a new task
	func saveTask(_ task: ToDo) {

		let realmTask = ToDoRealm(id: task.id,
								  title: task.title,
								  discription: task.description,
								  startDate: task.startDate,
								  endDate: task.endDate,
								  isCompleted: task.isCompleted)

		try! realm.write {
			realm.add(realmTask)
		}

	}

	/// Make changes with selected task and update in Realm
	func editTask(_ task: ToDo) {

		guard let realmTask = realm.object(ofType: ToDoRealm.self, forPrimaryKey: task.id)
		else { return }

		try! realm.write {
			realmTask.title = task.title
			realmTask.discription = task.description
			realmTask.startDate = task.startDate
			realmTask.endDate = task.endDate
			realmTask.isCompleted = task.isCompleted
		}
	}

	/// Remove selected task from Realm
	func deleteTask(_ task: ToDo) {

		guard let realmTask = realm.object(ofType: ToDoRealm.self, forPrimaryKey: task.id)
		else { return }

		try! realm.write {
			realm.delete(realmTask)
		}
	}

}
