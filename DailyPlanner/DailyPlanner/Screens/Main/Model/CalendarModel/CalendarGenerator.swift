import Foundation

/// A protocol that defines the requirements for generating calendar data.
protocol CalendarGeneratorProtocol {

	/// The base date used for generating calendar data.
	var baseDate: Date { get set }

	/// The number of weeks in the month corresponding to the base date.
	var numberOfWeeksInBaseDate: Int { get }

	/// The date service used for date calculations.
	var dateService: DateService { get set }

	/// Generates an array of `Day` objects representing all days in the month.
	///
	/// - Returns: An array of `Day` objects for the month corresponding to the base date.
	func generateDaysInMonth() -> [Day]

	/// Updates the number of weeks based on the current base date.
	mutating func updateNumberOfWeeks()
}

/// A structure that implements `CalendarGeneratorProtocol` to generate calendar data.
struct CalendarGenerator: CalendarGeneratorProtocol {

	// MARK: - Public Properties

	/// The base date used for generating calendar data.
	var baseDate: Date = Date() {
		didSet {
			updateNumberOfWeeks()
		}
	}

	/// The shared instance of `DateService` used for date calculations.
	var dateService = DateService.shared

	// MARK: - Private Properties

	/// The number of weeks in the month corresponding to the base date.
	private(set) var numberOfWeeksInBaseDate = 0

	/// A formatter used to convert dates into string representations of day numbers.
	private var dateFormatter: DateFormatter!

	// MARK: - Initialization

	/// Initializes a new instance of `CalendarGenerator`.
	///
	/// This initializer sets up the day formatter and updates the number of weeks
	/// based on the initial base date.
	init() {
		setupDayFormatter()
		updateNumberOfWeeks()
	}
}

// MARK: - Public Methods

extension CalendarGenerator {

	/// Updates the number of weeks in the month based on the current base date.
	///
	/// This method calculates how many weeks are present in the month of the base date
	/// and updates the `numberOfWeeksInBaseDate` property accordingly.
	mutating func updateNumberOfWeeks() {
		
		let calendar = dateService.calendar
		numberOfWeeksInBaseDate = calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
	}

	/// Generates an array of `Day` objects representing all days in the month.
	///
	/// This method calculates metadata for the month based on the base date,
	/// generates individual `Day` objects, and includes days from the next month if necessary.
	///
	/// - Returns: An array of `Day` objects for the month corresponding to the base date.
	func generateDaysInMonth() -> [Day] {

		guard let metadata = try? monthMetadata(for: baseDate) else {
			fatalError("An error occurred when generating the metadata for \(baseDate)")
		}

		let numberOfDaysInMonth = metadata.numberOfDays
		let offsetInInitialRow = metadata.firstDayWeekday
		let firstDayOfMonth = metadata.firstDay

		var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
			let isWithinDisplayedMonth = day >= offsetInInitialRow
			let dayOffset =
			isWithinDisplayedMonth ?
			day - offsetInInitialRow :
			-(offsetInInitialRow - day)

			return generateDay(
				offsetBy: dayOffset,
				for: firstDayOfMonth,
				isWithinDisplayedMonth: isWithinDisplayedMonth
			)
		}

		days += generateStartOfNextMonth(using: firstDayOfMonth)

		return days
	}
}

// MARK: - Private Methods

private extension CalendarGenerator {

	mutating func setupDayFormatter() {

		dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d"
	}

	func monthMetadata(for baseDate: Date) throws -> MonthMetadata {

		guard let numberOfDaysInMonth = dateService.calendar.range(
			of: .day,
			in: .month,
			for: baseDate)?.count,
			  let firstDayOfMonth = dateService.calendar.date(
				from: dateService.calendar.dateComponents([.year, .month], from: baseDate)
			  )
		else {
			throw CalendarDataError.metadataGeneration
		}

		let firstDayWeekday = dateService.calendar.component(.weekday, from: firstDayOfMonth)

		return MonthMetadata(
			numberOfDays: numberOfDaysInMonth,
			firstDay: firstDayOfMonth,
			firstDayWeekday: firstDayWeekday
		)
	}

	func generateDay(
		offsetBy dayOffset: Int,
		for baseDate: Date,
		isWithinDisplayedMonth: Bool
	) -> Day {

		let date = dateService.calendar.date(
			byAdding: .day,
			value: dayOffset,
			to: baseDate) ?? baseDate

		return Day(
			date: date,
			number: dateFormatter.string(from: date),
			isSelected: dateService.calendar.isDate(date, inSameDayAs: Date()),
			isWithinDisplayedMonth: isWithinDisplayedMonth
		)
	}

	func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {

		guard
			let lastDayInMonth = dateService.calendar.date(
				byAdding: DateComponents(month: 1, day: -1),
				to: firstDayOfDisplayedMonth
			)
		else {
			return []
		}

		let additionalDays = 7 - dateService.calendar.component(.weekday, from: lastDayInMonth)
		guard additionalDays > 0 else {
			return []
		}

		return (1...additionalDays).map { dayOffset in
			generateDay(
				offsetBy: dayOffset,
				for: lastDayInMonth,
				isWithinDisplayedMonth: false)
		}
	}
}

// MARK: - CalendarDataError

private extension CalendarGenerator {

	// An enumeration representing errors that can occur during calendar data generation.
	enum CalendarDataError: Error {
		case metadataGeneration
	}
}
