import Foundation
import RealmSwift

// use writeAsync to avoid loading MainThread with operations

/// Protocol for implementation of the manager to work with Realm Data Storage
protocol RealmDataManagerProtocol: AnyObject {

	/// Get all stored tasks for specific day
	func loadDailyTasks(date: Date) -> [ToDo]

	/// Load only selected task
	func loadSelectedTask(id: UUID) -> ToDo?

	/// Save or update a task
	func saveOrUpdateTask(_ task: ToDo)

	/// Remove selected task
	func deleteTask(_ task: ToDo)
}

/// Implementation of the manager to work with Realm Data Storage
final class RealmDataManager: RealmDataManagerProtocol {

	// MARK: - Private Properties

	private let realm: Realm

	// MARK: - Initialization

	init() throws {
		do {
			self.realm = try Realm()
		} catch {
			throw error
		}
	}

	// MARK: - Public Methods

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

			return ToDo.init(object: realmTask)
		}

		return tasks
	}

	/// Load only selected task
	func loadSelectedTask(id: UUID) -> ToDo? {

		guard let realmTask = realm.object(ofType: ToDoRealm.self,
												forPrimaryKey: id)
		else { return nil }

		let task = ToDo.init(object: realmTask)
		return task
	}

	/// Save or update a task
	func saveOrUpdateTask(_ task: ToDo) {
		let realmTask = ToDoRealm(task) // Convert ToDo to ToDoRealm

		do {
			try realm.write {
				realm.add(realmTask, update: .all)
			}
		} catch {
			print("Failed to save or update task: \(error.localizedDescription)")
		}
	}

	/// Remove selected task from Realm
	func deleteTask(_ task: ToDo) {

		guard let realmTask = realm.object(ofType: ToDoRealm.self, forPrimaryKey: task.id)
		else { return }

		do {
			try realm.write {
				realm.delete(realmTask)
			}
		} catch {
			print("Failed to delete task: \(error.localizedDescription)")
		}
	}

}
