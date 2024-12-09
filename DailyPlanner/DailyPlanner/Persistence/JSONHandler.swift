import Foundation

protocol JSONHandlerProtocol {

	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
	func encode<T: Encodable>(_ value: T) throws -> Data
}

final class JSONHandler: JSONHandlerProtocol {

	private let decoder = JSONDecoder()
	private let encoder = JSONEncoder()

	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
		return try decoder.decode(T.self, from: data)
	}

	func encode<T: Encodable>(_ value: T) throws -> Data {
		return try encoder.encode(value)
	}
}
