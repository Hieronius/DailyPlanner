import XCTest
@testable import DailyPlanner

class TaskViewControllerTests: XCTestCase {
	
	var viewController: TaskViewController!
	var mockDataManager: MockDataManager!
	
	override func setUp() {
		super.setUp()
		mockDataManager = MockDataManager()
	}
	
	override func tearDown() {
		viewController = nil
		mockDataManager = nil
		super.tearDown()
	}
	
	func testPrepareScreenForNewTask() {
		
		viewController = TaskViewController(screenMode: .newTask, dataManager: mockDataManager)
		
		viewController.loadViewIfNeeded()
		
		XCTAssertTrue(viewController.rootView.titleTextField.isFirstResponder)
		XCTAssertFalse(viewController.rootView.doneSwitch.isOn)
	}
	
	func testPrepareScreenForEditingTask() {
		
		let existingTask = ToDo(id: UUID(), title: "Existing Task", description: "Description", startDate: Date(), endDate: Date().addingTimeInterval(3600), isCompleted: true)
		mockDataManager.tasks = [existingTask]
		viewController = TaskViewController(screenMode: .detail(id: existingTask.id), dataManager: mockDataManager)
		
		viewController.loadViewIfNeeded()
		
		XCTAssertEqual(viewController.rootView.titleTextField.text, existingTask.title)
		XCTAssertEqual(viewController.rootView.descriptionTextField.text, existingTask.description)
		XCTAssertEqual(viewController.rootView.startDatePicker.date, existingTask.startDate)
		XCTAssertEqual(viewController.rootView.endDatePicker.date, existingTask.endDate)
		XCTAssertTrue(viewController.rootView.doneSwitch.isOn)
	}
	
	func testDoneButtonTappedCreatesNewTask() {
		
		viewController = TaskViewController(screenMode: .newTask, dataManager: mockDataManager)
		viewController.loadViewIfNeeded()
		
		viewController.rootView.titleTextField.text = "New Task"
		viewController.rootView.descriptionTextField.text = "New Description"
		viewController.rootView.startDatePicker.date = Date()
		viewController.rootView.endDatePicker.date = Date().addingTimeInterval(3600)
		viewController.rootView.doneSwitch.isOn = false
		
		viewController.doneButtonTapped()
		
		XCTAssertEqual(mockDataManager.tasks.count, 1)
		let createdTask = mockDataManager.tasks.first!
		
		XCTAssertEqual(createdTask.title, "New Task")
		XCTAssertEqual(createdTask.description, "New Description")
		XCTAssertFalse(createdTask.isCompleted)
	}
	
	func testDoneButtonTappedEditsExistingTask() {
		
		let existingTask = ToDo(id: UUID(), title: "Old Task", description: "Old Description", startDate: Date(), endDate: Date().addingTimeInterval(3600), isCompleted: true)
		
		mockDataManager.tasks = [existingTask]
		
		viewController = TaskViewController(screenMode: .detail(id: existingTask.id), dataManager: mockDataManager)
		
		viewController.loadViewIfNeeded()
		
		viewController.rootView.titleTextField.text = "Updated Task"
		viewController.rootView.descriptionTextField.text = "Updated Description"
		
		viewController.doneButtonTapped()
		
		XCTAssertEqual(mockDataManager.tasks.count, 1)
		
		let updatedTask = mockDataManager.tasks.first!
		
		XCTAssertEqual(updatedTask.title, "Updated Task")
		XCTAssertEqual(updatedTask.description, "Updated Description")
	}
	
	func testStartDatePickerValueChangedUpdatesEndDatePicker() {
		
		viewController = TaskViewController(screenMode: .newTask, dataManager: mockDataManager)
		viewController.loadViewIfNeeded()
		
		let startDate = Date()
		viewController.rootView.startDatePicker.date = startDate
		
		viewController.startDatePickerValueBeenChanged()
		
		let expectedEndDate = startDate.addingTimeInterval(3600)
		XCTAssertEqual(viewController.rootView.endDatePicker.date, expectedEndDate)
	}
}
