import UIKit

protocol CalendarViewDelegate: AnyObject {
	func dayTapped() // Update the method name to reflect month selection
}

final class MainView: UIView {

	// MARK: - Public Properties

	weak var delegate: CalendarViewDelegate?
	var collectionView: CalendarBodyCollectionView!
	var headerView: CalendarHeaderView!
	var footerView: CalendarFooterView!

	// MARK: - Initialization

	init() {
		super.init(frame: .zero)
		setupViews()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupViews() {

		setupCalendarHeaderView()
		setupCalendarCollectionView()
		setupCalendarFooterView()
	}

	private func setupCalendarCollectionView() {

		collectionView = CalendarBodyCollectionView()

		self.addSubview(collectionView)

		collectionView.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for collectionView
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
			collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
			collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
		])


	}

	private func setupCalendarHeaderView() {
		headerView = CalendarHeaderView()

		addSubview(headerView)

		headerView.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for headerView
		NSLayoutConstraint.activate([
			headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			headerView.heightAnchor.constraint(equalToConstant: 85)
		])

	}

	private func setupCalendarFooterView() {
		footerView = CalendarFooterView()

		addSubview(footerView)

		footerView.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for footerView
		NSLayoutConstraint.activate([
			footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
			footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
			footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
			footerView.heightAnchor.constraint(equalToConstant: 60)
		])

	}
}
