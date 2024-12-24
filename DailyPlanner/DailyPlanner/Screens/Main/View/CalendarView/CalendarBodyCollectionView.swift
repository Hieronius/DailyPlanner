import UIKit

/// A custom collection view for displaying the body of a calendar.
final class CalendarBodyCollectionView: UICollectionView {

	// MARK: - Initialization

	/// This initializer sets up the collection view with a flow layout and configures
	/// its properties for displaying calendar cells.
	init() {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0

		super.init(frame: .zero, collectionViewLayout: layout)

		configureCollectionView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private Methods

private extension CalendarBodyCollectionView {

	func configureCollectionView() {

		isScrollEnabled = false
		backgroundColor = .systemGray6

		register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
	}
}
