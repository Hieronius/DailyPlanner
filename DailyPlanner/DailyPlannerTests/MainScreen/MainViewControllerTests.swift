import XCTest
@testable import DailyPlanner

class MainViewControllerTests: XCTestCase {

	func testLoadDailyTasks() {

		let mockDataManager = MockDataManager()
		let mockJSONHandler = MockJSONHandler()
		let mockCalendarGenerator = MockCalendarGenerator()
		let viewController = MainViewController(dataManager: mockDataManager,
												jsonHandler: mockJSONHandler,
												calendarGenerator: mockCalendarGenerator)

		let expectedTasks = [ToDo(title: "Task 1"), ToDo(title: "Task 2")]
		mockDataManager.stubbedLoadDailyTasks = expectedTasks

		viewController.selectedDate = Date()
		viewController.loadDailyTasks()

		XCTAssertEqual(viewController.dailyVisibleTasks, expectedTasks)
	}

	func testCreateNewTask() {

		let mockDataManager = MockDataManager()
		let mockJSONHandler = MockJSONHandler()
		let mockCalendarGenerator = MockCalendarGenerator()
		let viewController = MainViewController(dataManager: mockDataManager,
												jsonHandler: mockJSONHandler,
												calendarGenerator: mockCalendarGenerator)

		let newTask = ToDo(title: "New Task")

		viewController.createNewTask(newTask)

		XCTAssertTrue(mockDataManager.tasks.contains(newTask))
	}

	func testDeleteTask() {

		let mockDataManager = MockDataManager()
		let mockJSONHandler = MockJSONHandler()
		let mockCalendarGenerator = MockCalendarGenerator()
		let viewController = MainViewController(dataManager: mockDataManager,
												jsonHandler: mockJSONHandler,
												calendarGenerator: mockCalendarGenerator)

		let taskToDelete = ToDo(title: "Delete Me")
		viewController.dailyVisibleTasks.append(taskToDelete)

		viewController.deleteTask(taskToDelete)

		XCTAssertFalse(viewController.dailyVisibleTasks.contains(taskToDelete))
	}

	func testUpdateCalendar() {

		let mockDataManager = MockDataManager()
		let mockJSONHandler = MockJSONHandler()
		let mockCalendarGenerator = MockCalendarGenerator()
		let viewController = MainViewController(dataManager: mockDataManager,
												jsonHandler: mockJSONHandler,
												calendarGenerator: mockCalendarGenerator)

		let expectedTasks = [ToDo(title: "Updated Task")]
		mockDataManager.stubbedLoadDailyTasks = expectedTasks

		viewController.selectedDate = Date()
		viewController.updateCalendar()

		XCTAssertEqual(viewController.dailyVisibleTasks, expectedTasks)
	}
}
