import UIKit

/// A custom header view for displaying an hour label in a table view.
final class HourHeaderView: UITableViewHeaderFooterView {

	// MARK: - Public Properties

	static let reuseIdentifier = "HourHeaderView"

	// MARK: - Private Properties

	private let titleLabel = UILabel()

	// MARK: - Initialization

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	/// Configures the header view with a given title.
	/// - Parameter title: The string to display as the header title.
	func configure(with title: String) {
		titleLabel.text = title
	}
}

// MARK: - Private Methods

private extension HourHeaderView {

	func setupView() {

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		titleLabel.textColor = .white
		contentView.addSubview(titleLabel)

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
		])
	}
}
