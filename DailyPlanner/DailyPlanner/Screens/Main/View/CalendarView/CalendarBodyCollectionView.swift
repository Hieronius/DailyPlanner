import UIKit

class CalendarBodyCollectionView: UICollectionView {

	// MARK: - Initialization

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

	// MARK: - Private Methods

	private func configureCollectionView() {
		isScrollEnabled = false
		backgroundColor = .systemGray6

		register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
	}
}
