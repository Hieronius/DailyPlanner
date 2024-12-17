import Foundation
import RealmSwift

/// Object to store Realm-related `ToDo`
final class ToDoRealm: Object {

	// MARK: - Public Properties

	@Persisted var id: UUID
	@Persisted var title: String
	@Persisted var discription: String
	@Persisted var startDate: Date
	@Persisted var endDate: Date
	@Persisted var isCompleted: Bool

	// MARK: - Initialization

	convenience init(
		id: UUID,
		title: String,
		discription: String,
		startDate: Date,
		endDate: Date,
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
