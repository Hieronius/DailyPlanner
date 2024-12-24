import UIKit

/// A custom collection view cell that represents a single day in a calendar.
final class CalendarCell: UICollectionViewCell {

	// MARK: - Public Properties

	/// The reuse identifier for the cell.
	static let reuseIdentifier = String(describing: CalendarCell.self)

	/// The date associated with this cell.
	var day: Day? {
		didSet {

			guard let day = day else { return }
			numberLabel.text = day.number
			updateSelectionStatus()
		}
	}

	// Property to track whether the cell is selected
	var isSelectedCell: Bool = false {
		
		didSet {
			selectionBackgroundView.isHidden = !isSelectedCell
			numberLabel.textColor = isSelectedCell ? (isSmallScreenSize ? .systemRed : .white) : (day?.isWithinDisplayedMonth == true ? .label : .secondaryLabel)
		}
	}

	// MARK: - Private Properties

	private var selectionBackgroundView: UIView!
	private var numberLabel: UILabel!

	// MARK: - Initialization

	/// This initializer sets up the cell's views and layout.
	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Layout

	override func layoutSubviews() {
		super.layoutSubviews()
	}
}

// MARK: - Setup Cell

private extension CalendarCell {

	func setupViews() {

		setupBackground()
		setupNumberLabel()
		setupCollectionViewCellConstraints()
	}

	func setupBackground() {
		
		selectionBackgroundView = UIView()
		selectionBackgroundView.clipsToBounds = true
		selectionBackgroundView.backgroundColor = .systemRed

		contentView.addSubview(selectionBackgroundView)

		selectionBackgroundView.layer.cornerRadius = 45 / 2
	}

	func setupNumberLabel() {

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

		NSLayoutConstraint.activate([
			selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
			selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
			selectionBackgroundView.widthAnchor.constraint(equalToConstant: 45),
			selectionBackgroundView.heightAnchor.constraint(equalToConstant: 45)
		])

		NSLayoutConstraint.activate([
			numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
}

// MARK: - Helper Methods

private extension CalendarCell {

	/// Updates the selection status of the cell.
	func updateSelectionStatus() {

		guard let day = day else { return }

		if day.isSelected {
			applySelectedStyle()
		} else {
			applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
		}
	}

	/// Checks if the screen size is small.
	var isSmallScreenSize: Bool {

		let isCompact = traitCollection.horizontalSizeClass == .compact
		let smallWidth = UIScreen.main.bounds.width <= 350
		let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height

		return isCompact && (smallWidth || widthGreaterThanHeight)
	}

	/// Applies the selected style to the cell.
	func applySelectedStyle() {

		numberLabel.textColor = isSmallScreenSize ? .systemRed : .white
		selectionBackgroundView.isHidden = isSmallScreenSize
	}

	/// Applies the default style to the cell.
	///
	/// - Parameter isWithinDisplayedMonth: A Boolean value indicating whether the date is within the displayed month.
	func applyDefaultStyle(isWithinDisplayedMonth: Bool) {

		numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
		selectionBackgroundView.isHidden = true
	}
}
