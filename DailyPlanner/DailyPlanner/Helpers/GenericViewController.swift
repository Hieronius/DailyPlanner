import UIKit

/// A wrapper to automatically use `RootView` with Controller by `rootView` property
class GenericViewController<T: UIView>: UIViewController {

	// MARK: - Public Properties

	/// `rootView` to be used directly from ViewController
	public var rootView: T {
		return view as! T
	}

	// MARK: - Public Methods

	override open func loadView() {
		self.view = T()
	}
}
