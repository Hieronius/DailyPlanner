import Foundation

/// Data type to define what mode we enter to
enum TaskScreenMode {

	/// `new task` button been pressed
	case newTask

	/// Specific task been selected
	case detail(id: UUID)
}
