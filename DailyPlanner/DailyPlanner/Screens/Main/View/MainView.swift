import UIKit

// MARK: May be should be removed because i have calendar at the same screen
protocol CalendarViewDelegate: AnyObject {
	/// Update the method name to reflect month selection
	func dayTapped()
}

final class MainView: UIView {

	// MARK: - Public Properties

	weak var delegate: CalendarViewDelegate?

	var calendarHeaderView: CalendarHeaderView!
	var calendarCollectionView: CalendarBodyCollectionView!
	var calendarFooterView: CalendarFooterView!

	var tasksTableView: TasksTableView!

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

		setupMainTableView()
	}

	private func setupCalendarCollectionView() {

		calendarCollectionView = CalendarBodyCollectionView()

		self.addSubview(calendarCollectionView)

		calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for collectionView
		NSLayoutConstraint.activate([
			calendarCollectionView.leadingAnchor.constraint(equalTo: calendarHeaderView.leadingAnchor),
			calendarCollectionView.trailingAnchor.constraint(equalTo: calendarHeaderView.trailingAnchor),
			calendarCollectionView.topAnchor.constraint(equalTo: calendarHeaderView.bottomAnchor),
			calendarCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
		])


	}

	private func setupCalendarHeaderView() {
		calendarHeaderView = CalendarHeaderView()

		addSubview(calendarHeaderView)

		calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for headerView
		NSLayoutConstraint.activate([
			calendarHeaderView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			calendarHeaderView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			calendarHeaderView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			calendarHeaderView.heightAnchor.constraint(equalToConstant: 85)
		])

	}

	private func setupCalendarFooterView() {
		calendarFooterView = CalendarFooterView()

		addSubview(calendarFooterView)

		calendarFooterView.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for footerView
		NSLayoutConstraint.activate([
			calendarFooterView.leadingAnchor.constraint(equalTo: calendarCollectionView.leadingAnchor),
			calendarFooterView.trailingAnchor.constraint(equalTo: calendarCollectionView.trailingAnchor),
			calendarFooterView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor),
			calendarFooterView.heightAnchor.constraint(equalToConstant: 60)
		])
	}

	private func setupMainTableView() {
		   tasksTableView = TasksTableView()

		   addSubview(tasksTableView)

		   tasksTableView.translatesAutoresizingMaskIntoConstraints = false

		   NSLayoutConstraint.activate([
			   tasksTableView.topAnchor.constraint(equalTo: calendarFooterView.bottomAnchor, constant: 15),
			   tasksTableView.leadingAnchor.constraint(equalTo: calendarFooterView.leadingAnchor),
			   tasksTableView.trailingAnchor.constraint(equalTo: calendarFooterView.trailingAnchor),
			   tasksTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		   ])
	   }
}
