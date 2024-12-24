import Foundation

/// A structure representing a single day in a calendar.
struct Day {

	/// The date corresponding to this day.
	let date: Date

	/// The numerical representation of the day (e.g., "1", "15").
	let number: String

	/// A Boolean value indicating whether this day is currently selected.
	var isSelected: Bool

	/// A Boolean value indicating whether this day falls within the currently displayed month.
	let isWithinDisplayedMonth: Bool
}
