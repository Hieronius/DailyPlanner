import Foundation
import RealmSwift

/// Object to store Realm-related `ToDo`
final class ToDoRealm: Object {

	// MARK: - Public Properties

	/// The unique identifier for the to-do item.
	@Persisted(primaryKey: true) var id: UUID

	/// The title of the to-do item.
	@Persisted var title: String

	/// A description of the to-do item.
	@Persisted var discription: String

	/// The start date for the to-do item.
	@Persisted var startDate: Date?

	/// The end date for the to-do item.
	@Persisted var endDate: Date?

	/// A Boolean value indicating whether the to-do item is completed.
	@Persisted var isCompleted: Bool

	// MARK: - Initialization

	/// Initializes a new instance of `ToDoRealm`.
	///
	/// This convenience initializer sets up a new `ToDoRealm` object with the provided values.
	///
	/// - Parameters:
	///   - id: The unique identifier for the to-do item.
	///   - title: The title of the to-do item.
	///   - discription: A description of the to-do item.
	///   - startDate: The start date for the to-do item (optional).
	///   - endDate: The end date for the to-do item (optional).
	///   - isCompleted: A Boolean indicating whether the to-do item is completed.
	convenience init(

		id: UUID,
		title: String,
		discription: String,
		startDate: Date?,
		endDate: Date?,
		isCompleted: Bool
	) {

		self.init()
		self.id = id
		self.title = title
		self.discription = discription
		self.startDate = startDate
		self.endDate = endDate
		self.isCompleted = isCompleted
	}
}

// MARK: - Convertion from `ToDo`

extension ToDoRealm {

	/// Initializes a new instance of `ToDoRealm` from a `ToDo` object.
	///
	/// This convenience initializer creates a `ToDoRealm` object by copying properties
	/// from an existing `ToDo` object.
	///
	/// - Parameter toDo: The `ToDo` object from which to initialize the `ToDoRealm`.
	convenience init(_ toDo: ToDo) {
		
		self.init()
		self.id = toDo.id
		self.title = toDo.title
		self.discription = toDo.description
		self.startDate = toDo.startDate
		self.endDate = toDo.endDate
		self.isCompleted = toDo.isCompleted
	}
}
