import Foundation

class DateService {

	// MARK: - Public Properties

	static let shared = DateService()

	let calendar = Calendar(identifier: .gregorian)

	// MARK: - Initialization

	private init() {}


	// Additional methods related to date operations can go here
}
