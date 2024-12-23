import Foundation

protocol CalendarGeneratorProtocol {
	var baseDate: Date { get set }
	var numberOfWeeksInBaseDate: Int { get }
	var dateService: DateService { get set }
	func generateDaysInMonth() -> [Day]
	mutating func updateNumberOfWeeks()
}

struct CalendarGenerator: CalendarGeneratorProtocol {

	var baseDate: Date = Date() {
		didSet {
			updateNumberOfWeeks()
		}
	}

	var dateService = DateService.shared

	private(set) var numberOfWeeksInBaseDate = 0
	private var dateFormatter: DateFormatter!

	init() {
		setupDayFormatter()
		updateNumberOfWeeks()
	}

	private mutating func setupDayFormatter() {
		dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d"
	}

	mutating func updateNumberOfWeeks() {
		let calendar = dateService.calendar
		numberOfWeeksInBaseDate = calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
	}

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

	private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
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

	private func generateDay(
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

	private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
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

	enum CalendarDataError: Error {
		case metadataGeneration
	}
}


