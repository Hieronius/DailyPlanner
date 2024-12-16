import UIKit

final class CustomTextField: UITextField {

	// Padding values
	let padding: CGFloat = 10.0

	// Override the textRect method to add padding to the text
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: padding)
	}

	// Override the placeholderRect method to add padding to the placeholder
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: padding)
	}

	// Override the editingRect method to add padding when editing
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: padding)
	}
}
