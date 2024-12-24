import UIKit

/// A custom text field that provides padding for its text and placeholder.
final class CustomTextField: UITextField {

	/// The amount of padding to apply around the text and placeholder.
	let padding: CGFloat = 10.0

	/// Returns the rectangle for the text within the bounds of the text field.
	///
	/// This method overrides the default implementation to apply padding to the text
	/// rectangle.
	///
	/// - Parameter bounds: The bounding rectangle for the text field.
	/// - Returns: A rectangle that represents the area where the text should be drawn.
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: padding)
	}

	/// Returns the rectangle for the placeholder within the bounds of the text field.
	///
	/// This method overrides the default implementation to apply padding to the placeholder
	/// rectangle.
	///
	/// - Parameter bounds: The bounding rectangle for the text field.
	/// - Returns: A rectangle that represents the area where the placeholder should be drawn.
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: padding)
	}

	/// Returns the rectangle for editing within the bounds of the text field.
	///
	/// This method overrides the default implementation to apply padding to the editing
	/// rectangle.
	///
	/// - Parameter bounds: The bounding rectangle for the text field.
	/// - Returns: A rectangle that represents the area where user input should be drawn.
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: padding)
	}
}
