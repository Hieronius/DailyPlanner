import UIKit

class HourHeaderView: UICollectionReusableView {
	static let reuseIdentifier = "HourHeaderView"

	let titleLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)

		// Set constraints for titleLabel
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
		])

		titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
		titleLabel.textColor = .white
	}

	func configure(with text: String) {
		titleLabel.text = text
	}
}
