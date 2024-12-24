import Foundation

/// A singleton service for handling date-related operations.
final class DateService {

	// MARK: - Public Properties

	/// This property provides a global access point to the `DateService` instance.
	static let shared = DateService()

	/// The calendar used for date calculations.
	let calendar = Calendar(identifier: .gregorian)

	// MARK: - Initialization
	
	/// Private initializer to enforce the singleton pattern.
	private init() {}
}
