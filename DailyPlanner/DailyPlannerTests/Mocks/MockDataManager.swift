import Foundation
import RealmSwift
@testable import DailyPlanner

/// Mock for RealmDataManagerProtocol
class MockDataManager: RealmDataManagerProtocol {
	
	var stubbedLoadDailyTasks: [ToDo] = []
	var tasks: [ToDo] = []
	
	func loadDailyTasks(date: Date) -> [ToDo] {
		return stubbedLoadDailyTasks
	}
	
	func loadSelectedTask(id: UUID) -> ToDo? {
		return tasks.first { $0.id == id }
	}
	
	func getAllTasks() -> [ToDo] {
		return tasks
	}
	
	func saveAllTasks(_ tasks: [ToDo]) {
		self.tasks.append(contentsOf: tasks)
	}
	
	func saveOrUpdateTask(_ task: ToDo) {

		if let index = tasks.firstIndex(where: { $0.id == task.id }) {
			tasks[index] = task
		} else {
			tasks.append(task)
		}
	}
	
	func deleteTask(_ task: ToDo) {

		if let index = tasks.firstIndex(where: { $0.id == task.id }) {
			tasks.remove(at: index)
		}
	}
	
	func deleteAllTasks() {
		tasks.removeAll()
	}
}

