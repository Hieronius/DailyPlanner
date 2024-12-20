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
	func encodeTodos(_ todos: [ToDo]) throws -> Data {

		let todoJSONs = todos.map { ToDoJSON(from: $0) }
		return try encoder.encode(todoJSONs)
	}
}
