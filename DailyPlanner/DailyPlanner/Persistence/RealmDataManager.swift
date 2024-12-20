import Foundation
import RealmSwift

// MARK: use writeAsync to avoid loading MainThread with operations

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

	/// Delete all stored tasks
	func deleteAllTasks()
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

		// Get the start and end of the day
		guard let startOfDay = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: date)),
			  let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
			return []
		}

		// Create a predicate that matches tasks with startDate within the specified range
		let predicate = NSPredicate(format: "startDate >= %@ AND startDate < %@", startOfDay as NSDate, endOfDay as NSDate)

		let realmTasks = realm.objects(ToDoRealm.self).filter(predicate)

		// Convert Realm objects to ToDo models
		let tasks: [ToDo] = realmTasks.map { realmTask in
			return ToDo(object: realmTask)
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

	/// Delete all stored tasks
	func deleteAllTasks() {

		do {
			try realm.write {
				realm.deleteAll()
			}
		} catch {
			print("Failed to erase the storage")
		}
	}
}
