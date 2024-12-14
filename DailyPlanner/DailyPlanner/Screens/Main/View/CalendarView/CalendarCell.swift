import UIKit

final class CalendarCell: UICollectionViewCell {

	// MARK: - Private Properties

	private var selectionBackgroundView: UIView!
	private var numberLabel: UILabel!

	// MARK: - Public Properties

	static let reuseIdentifier = String(describing: CalendarCell.self)

	/// The date associated with this cell.
	var day: Day? {
		didSet {
			guard let day = day else { return }
			numberLabel.text = day.number
			updateSelectionStatus()
		}
	}

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Setup

	/// Sets up the subviews of the cell.
	private func setupViews() {
		setupBackground()
		setupNumberLabel()
		setupCollectionViewCellConstraints()
	}

	private func setupBackground() {
		selectionBackgroundView = UIView()
		selectionBackgroundView.clipsToBounds = true
		selectionBackgroundView.backgroundColor = .systemRed

		contentView.addSubview(selectionBackgroundView)

		selectionBackgroundView.layer.cornerRadius = 45 / 2
	}

	private func setupNumberLabel() {
		numberLabel = UILabel()
		numberLabel.translatesAutoresizingMaskIntoConstraints = false
		numberLabel.textAlignment = .center
		numberLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		numberLabel.textColor = .label

		contentView.addSubview(numberLabel)
	}

	func setupCollectionViewCellConstraints() {
		
		selectionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
		numberLabel.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for selectionBackgroundView
		NSLayoutConstraint.activate([
			selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
			selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
			selectionBackgroundView.widthAnchor.constraint(equalToConstant: 45),
			selectionBackgroundView.heightAnchor.constraint(equalToConstant: 45)
		])

		// Add constraints for numberLabel
		NSLayoutConstraint.activate([
			numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}

	// MARK: - Layout

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	// MARK: - Helper Methods

	/// Updates the selection status of the cell.
	private func updateSelectionStatus() {
		guard let day = day else { return }

		if day.isSelected {
			applySelectedStyle()
		} else {
			applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
		}
	}

	/// Checks if the screen size is small.
	private var isSmallScreenSize: Bool {
		let isCompact = traitCollection.horizontalSizeClass == .compact
		let smallWidth = UIScreen.main.bounds.width <= 350
		let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height

		return isCompact && (smallWidth || widthGreaterThanHeight)
	}

	/// Applies the selected style to the cell.
	private func applySelectedStyle() {
		numberLabel.textColor = isSmallScreenSize ? .systemRed : .white
		selectionBackgroundView.isHidden = isSmallScreenSize
	}

	/// Applies the default style to the cell.
	///
	/// - Parameter isWithinDisplayedMonth: A Boolean value indicating whether the date is within the displayed month.
	private func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
		numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
		selectionBackgroundView.isHidden = true
	}
}
