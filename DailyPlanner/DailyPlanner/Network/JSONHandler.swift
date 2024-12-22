import Foundation

/// Protocol for JSONHandler service implementation
protocol JSONHandlerProtocol {
	
	/// Decodes the given data into a specified type.
	///
	/// - Parameters:
	///   - type: The type of the value to decode.
	///   - data: The data to decode.
	/// - Throws: An error if decoding fails.
	/// - Returns: An instance of the specified type.
	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T

	/// Encodes a value into a JSON format.
	///
	/// - Parameter value: The value to encode.
	/// - Throws: An error if encoding fails.
	/// - Returns: A `Data` object containing the encoded JSON.
	func encode<T: Encodable>(_ value: T) throws -> Data

	/// Decodes an array of `ToDoJSON` objects from the provided data.
	///
	/// - Parameter data: The data to decode into an array of `ToDoJSON`.
	/// - Throws: An error if decoding fails.
	/// - Returns: An array of `ToDoJSON` objects.
	func decodeToDoJSON(from data: Data) throws -> [ToDoJSON]

	/// Encodes an array of `ToDo` objects into JSON format.
	///
	/// - Parameter todos: An array of `ToDo` objects to encode.
	/// - Throws: An error if encoding fails.
	/// - Returns: A `Data` object containing the encoded JSON.
	func encodeTodos(_ todos: [ToDo]) throws -> Data

	/// Saves an array of `ToDo` objects to a local JSON file.
	///
	/// - Parameters:
	///   - todos: An array of `ToDo` objects to save to the file.
	///   - filename: The name of the file where the JSON data will be saved, including the `.json` extension.
	/// - Throws: An error if encoding fails or if writing to the file fails.
	func saveTodosToFile(_ todos: [ToDo], filename: String) throws

	/// Loads an array of `ToDo` objects from a local JSON file.
	///
	/// - Parameter filename: The name of the file from which to load the JSON data, including the `.json` extension.
	/// - Throws: An error if reading from the file fails or if decoding fails.
	/// - Returns: An array of `ToDo` objects loaded from the JSON file.
	func loadTodosFromFile(filename: String) throws -> [ToDo]
}

/// Implementation of the JSONHandler service
final class JSONHandler: JSONHandlerProtocol {

	private let decoder = JSONDecoder()
	private let encoder = JSONEncoder()

	/// Decodes the given data into a specified type.
	///
	/// This method uses Swift's `JSONDecoder` to convert the provided data into
	/// an instance of the specified type. It can throw an error if the decoding
	/// fails due to invalid data or mismatched types.
	///
	/// - Parameters:
	///   - type: The type of the value to decode.
	///   - data: The data to decode.
	/// - Throws: An error if decoding fails.
	/// - Returns: An instance of the specified type.
	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {

		return try decoder.decode(T.self, from: data)
	}

	/// Encodes a value into a JSON format.
	///
	/// This method uses Swift's `JSONEncoder` to convert a given value into
	/// its JSON representation. It can throw an error if the encoding fails
	/// due to unsupported types or invalid values.
	///
	/// - Parameter value: The value to encode.
	/// - Throws: An error if encoding fails.
	/// - Returns: A `Data` object containing the encoded JSON.
	func encode<T: Encodable>(_ value: T) throws -> Data {

		return try encoder.encode(value)
	}

	/// Decodes an array of `ToDoJSON` objects from the provided data.
	///
	/// - Parameter data: The data to decode into an array of `ToDoJSON`.
	/// - Throws: An error if decoding fails.
	/// - Returns: An array of `ToDoJSON` objects.
	func decodeToDoJSON(from data: Data) throws -> [ToDoJSON] {

		return try decode([ToDoJSON].self, from: data)
	}

	/// Encodes an array of `ToDo` objects into JSON format.
	///
	/// This method converts each `ToDo` object into its corresponding `ToDoJSON`
	/// representation and encodes them as an array.
	///
	/// - Parameter todos: An array of `ToDo` objects to encode.
	/// - Throws: An error if encoding fails.
	/// - Returns: A `Data` object containing the encoded JSON.
	@discardableResult
	func encodeTodos(_ todos: [ToDo]) throws -> Data {

		let todoJSONs = todos.map { ToDoJSON(from: $0) }
		return try encoder.encode(todoJSONs)
	}

	/// Saves an array of `ToDo` objects to a local JSON file.
	///
	/// This method encodes the provided array of `ToDo` objects into JSON format
	/// and writes it to a specified file in the app's Documents directory.
	/// It can throw an error if encoding fails or if writing to the file fails.
	///
	/// - Parameters:
	///   - todos: An array of `ToDo` objects to save to the file.
	///   - filename: The name of the file where the JSON data will be saved, including the `.json` extension.
	/// - Throws: An error if encoding fails or if writing to the file fails.
	func saveTodosToFile(_ todos: [ToDo], filename: String) throws {

		let data = try encodeTodos(todos)
		let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
		try data.write(to: fileURL)
	}

	/// Loads an array of `ToDo` objects from a local JSON file.
	///
	/// This method reads data from a specified JSON file in the app's Documents directory,
	/// decodes it into an array of `ToDoJSON` objects, and then maps these into `ToDo` objects.
	/// It can throw an error if reading from the file fails or if decoding fails.
	///
	/// - Parameter filename: The name of the file from which to load the JSON data, including the `.json` extension.
	/// - Throws: An error if reading from the file fails or if decoding fails.
	/// - Returns: An array of `ToDo` objects loaded from the JSON file.
	func loadTodosFromFile(filename: String) throws -> [ToDo] {

		let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
		let data = try Data(contentsOf: fileURL)
		let todoJSONs = try decodeToDoJSON(from: data)
		return todoJSONs.map { ToDo(json: $0) }
	}

	/// Helper function to get Documents Directory
	private func getDocumentsDirectory() -> URL {

		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	}
}
