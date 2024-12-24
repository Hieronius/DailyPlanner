import Foundation
import RealmSwift

/// Protocol for implementation of the manager to work with Realm Data Storage
protocol RealmDataManagerProtocol: AnyObject {

	/// Retrieves all stored tasks for a specific day.
	///
	/// - Parameter date: The date for which to load tasks.
	/// - Returns: An array of `ToDo` objects representing the tasks for the specified day.
	func loadDailyTasks(date: Date) -> [ToDo]

	/// Loads a selected task by its unique identifier.
	///
	/// - Parameter id: The unique identifier of the task to load.
	/// - Returns: The corresponding `ToDo` object, or `nil` if not found.
	func loadSelectedTask(id: UUID) -> ToDo?

	/// Fetches all existing tasks from the storage.
	///
	/// - Returns: An array of all `ToDo` objects stored in Realm.
	func getAllTasks() -> [ToDo]

	/// Saves an array of tasks to the Realm database.
	///
	/// - Parameter tasks: An array of `ToDo` objects to save.
	func saveAllTasks(_ tasks: [ToDo])

	/// Saves or updates a single task in the Realm database.
	///
	/// - Parameter task: The `ToDo` object to save or update.
	func saveOrUpdateTask(_ task: ToDo)

	/// Removes a selected task from the Realm database.
	///
	/// - Parameter task: The `ToDo` object to delete.
	func deleteTask(_ task: ToDo)

	/// Deletes all stored tasks from the Realm database.
	func deleteAllTasks()
}

/// Implementation of the manager to work with Realm Data Storage
final class RealmDataManager: RealmDataManagerProtocol {

	// MARK: - Private Properties

	private let realm: Realm

	// MARK: - Initialization

	/// Initializes a new instance of `RealmDataManager`.
	///
	/// This initializer attempts to create a new instance of the Realm database.
	/// It throws an error if initialization fails.
	///
	/// - Throws: An error if the Realm instance cannot be created.
	init() throws {
		
		do {
			self.realm = try Realm()
		} catch {
			throw error
		}
	}
}

// MARK: - Public Methods

extension RealmDataManager {

	/// Retrieves all stored tasks for a specific day.
	///
	/// This method calculates the start and end of the specified day and fetches
	/// tasks that fall within that range from the Realm database.
	///
	/// - Parameter date: The date for which to load tasks.
	/// - Returns: An array of `ToDo` objects representing the tasks for the specified day.
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

	/// Loads a selected task by its unique identifier.
	///
	/// This method retrieves a single task from the Realm database based on its ID.
	///
	/// - Parameter id: The unique identifier of the task to load.
	/// - Returns: The corresponding `ToDo` object, or `nil` if not found.
	func loadSelectedTask(id: UUID) -> ToDo? {

		guard let realmTask = realm.object(ofType: ToDoRealm.self,
										   forPrimaryKey: id)
		else { return nil }

		let task = ToDo.init(object: realmTask)
		return task
	}

	/// Fetches all existing tasks from the storage.
	///
	/// This method retrieves all tasks stored in the Realm database and converts them
	/// into an array of `ToDo` objects.
	///
	/// - Returns: An array of all `ToDo` objects stored in Realm.
	func getAllTasks() -> [ToDo] {

		let realmTasks = realm.objects(ToDoRealm.self)

		let tasks: [ToDo] = realmTasks.map { realmTask in
			return ToDo(object: realmTask)
		}

		return tasks
	}

	/// Saves an array of tasks to the Realm database.
	///
	/// This method converts each `ToDo` object into a corresponding `ToDoRealm`
	/// object and saves them in a single transaction.
	///
	/// - Parameter tasks: An array of `ToDo` objects to save.
	func saveAllTasks(_ tasks: [ToDo]) {

		let realmTasks = tasks.map { task in
			ToDoRealm(task)
		}

		do {
			try realm.write {
				realm.add(realmTasks)
			}
		} catch {
			print("Failed to save an array of tasks: \(error.localizedDescription)")
		}
	}

	/// Saves or updates a single task in the Realm database.
	///
	/// This method converts a `ToDo` object into a corresponding `ToDoRealm`
	/// object and saves or updates it in a single transaction based on its primary key.
	///
	/// - Parameter task: The `ToDo` object to save or update.
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

	/// Removes a selected task from the Realm database.
	///
	/// This method deletes a specific task identified by its ID from the storage,
	/// if it exists in the database.
	///
	/// - Parameter task: The `ToDo` object to delete.
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

	/// Deletes all stored tasks from the Realm database.
	///
	/// This method removes all entries from the storage in a single transaction,
	/// effectively clearing out all existing tasks.
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
