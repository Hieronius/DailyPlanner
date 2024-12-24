import Foundation
@testable import DailyPlanner

/// Mock for JSONHandlerProtocol
class MockJSONHandler: JSONHandlerProtocol {

	var shouldThrowError = false
	var mockEncodedData: Data?
	var mockDecodedTodos: [ToDo] = []

	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {

		if shouldThrowError {
			throw NSError(domain: "MockError", code: 1, userInfo: nil)
		}
		return try JSONDecoder().decode(T.self, from: data)
	}

	func encode<T: Encodable>(_ value: T) throws -> Data {

		if shouldThrowError {
			throw NSError(domain: "MockError", code: 1, userInfo: nil)
		}
		return try JSONEncoder().encode(value)
	}

	func decodeToDoJSON(from data: Data) throws -> [ToDoJSON] {

		if shouldThrowError {
			throw NSError(domain: "MockError", code: 1, userInfo: nil)
		}
		return try decode([ToDoJSON].self, from: data)
	}

	func encodeTodos(_ todos: [ToDo]) throws -> Data {
		if shouldThrowError {

			throw NSError(domain: "MockError", code: 1, userInfo: nil)
		}
		return try encode(todos)
	}

	func saveTodosToFile(_ todos: [ToDo], filename: String) throws {

		if shouldThrowError {
			throw NSError(domain: "MockError", code: 1, userInfo: nil)
		}
		mockEncodedData = try encodeTodos(todos)
	}

	func loadTodosFromFile(filename: String) throws -> [ToDo] {

		if shouldThrowError {
			throw NSError(domain: "MockError", code: 1, userInfo: nil)
		}
		return mockDecodedTodos
	}
}
