import UIKit

class HourHeaderView: UITableViewHeaderFooterView {

	static let reuseIdentifier = "HourHeaderView"
	private let titleLabel = UILabel()

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		titleLabel.textColor = .white
		contentView.addSubview(titleLabel)

		// Set constraints for titleLabel
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
		])
	}

	func configure(with title: String) {
		titleLabel.text = title
	}
}
