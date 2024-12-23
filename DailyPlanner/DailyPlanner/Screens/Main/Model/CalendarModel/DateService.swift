import Foundation

final class DateService {

	// MARK: - Public Properties

	static let shared = DateService()

	let calendar = Calendar(identifier: .gregorian)

	// MARK: - Initialization

	private init() {}
}
