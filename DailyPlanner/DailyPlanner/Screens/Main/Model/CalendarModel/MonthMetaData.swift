import Foundation

/// A structure that holds metadata about a specific month.
struct MonthMetadata {

	/// The total number of days in the month.
	let numberOfDays: Int

	/// The date representing the first day of the month.
	let firstDay: Date

	/// The weekday of the first day of the month, represented as an integer.
	/// (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
	let firstDayWeekday: Int
}
