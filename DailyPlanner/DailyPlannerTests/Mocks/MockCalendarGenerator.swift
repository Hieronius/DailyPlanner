import Foundation
@testable import DailyPlanner

/// Mock for CalendarGeneratorProtocol
class MockCalendarGenerator: CalendarGeneratorProtocol {

	var baseDate: Date = Date()
	var dateService: DateService = DateService.shared

	var numberOfWeeksInBaseDate: Int = 0

	var mockDays: [Day] = []

	func generateDaysInMonth() -> [Day] {
		return mockDays
	}

	func updateNumberOfWeeks() {
		numberOfWeeksInBaseDate = (mockDays.count + 6) / 7
	}
}
