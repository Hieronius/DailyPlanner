import UIKit

/// A custom view that serves as the main interface for the calendar and task management.
final class MainView: UIView {

	// MARK: - Public Properties

	/// The header view displaying the current month and navigation buttons.
	var calendarHeaderView: CalendarHeaderView!

	/// The collection view displaying the days of the calendar.
	var calendarCollectionView: CalendarBodyCollectionView!

	/// The footer view containing navigation buttons for month selection.
	var calendarFooterView: CalendarFooterView!

	/// The table view displaying the list of tasks.
	var tasksTableView: TasksTableView!

	// MARK: - Initialization

	/// This initializer sets up the main view and its subviews.
	init() {
		super.init(frame: .zero)
		setupViews()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private Methods

private extension MainView {

	func setupViews() {

		setupCalendarHeaderView()
		setupCalendarCollectionView()
		setupCalendarFooterView()

		setupMainTableView()
	}

	func setupCalendarCollectionView() {

		calendarCollectionView = CalendarBodyCollectionView()

		addSubview(calendarCollectionView)

		calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			calendarCollectionView.leadingAnchor.constraint(equalTo: calendarHeaderView.leadingAnchor),
			calendarCollectionView.trailingAnchor.constraint(equalTo: calendarHeaderView.trailingAnchor),
			calendarCollectionView.topAnchor.constraint(equalTo: calendarHeaderView.bottomAnchor),
			calendarCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
		])
	}

	func setupCalendarHeaderView() {

		calendarHeaderView = CalendarHeaderView()

		addSubview(calendarHeaderView)

		calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			calendarHeaderView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			calendarHeaderView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			calendarHeaderView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			calendarHeaderView.heightAnchor.constraint(equalToConstant: 85)
		])

	}

	func setupCalendarFooterView() {

		calendarFooterView = CalendarFooterView()

		addSubview(calendarFooterView)

		calendarFooterView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			calendarFooterView.leadingAnchor.constraint(equalTo: calendarCollectionView.leadingAnchor),
			calendarFooterView.trailingAnchor.constraint(equalTo: calendarCollectionView.trailingAnchor),
			calendarFooterView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor),
			calendarFooterView.heightAnchor.constraint(equalToConstant: 60)
		])
	}

	func setupMainTableView() {

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
