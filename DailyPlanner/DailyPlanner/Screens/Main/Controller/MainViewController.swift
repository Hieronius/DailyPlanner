import UIKit

final class MainViewController: GenericViewController<MainView> {

	// MARK: - Private Properties

	/// Selected date on the calendar to load existing tasks
	private var selectedDate: Date? = nil

	private lazy var days = generateDaysInMonth(for: baseDate)
	private var dateFormatter: DateFormatter!
	private let dateService = DateService.shared
	private var numberOfWeeksInBaseDate = 0

	private var dataSource: UITableViewDiffableDataSource<HourSection, ToDo>!

	let todosBySection: [HourSection: [ToDo]] = [

		.hour0: [ToDo(id: 1, title: "Task 1", description: "Description 1", startDate: "Start", endDate: "End", isCompleted: false),

				 ToDo(id: 2, title: "Task 1.1", description: "Description 1.1", startDate: "Start", endDate: "End", isCompleted: false),

				 ToDo(id: 3, title: "Task 1.2", description: "Description 1.2", startDate: "Start", endDate: "End", isCompleted: false),
				 
				 ToDo(id: 4, title: "Task 1.3", description: "Description 1.3", startDate: "Start", endDate: "End", isCompleted: false)],

		.hour1: [ToDo(id: 2, title: "Task 2", description: "Description 2", startDate: "Start", endDate: "End", isCompleted: false)]
	]


	private var baseDate: Date = Date() {
	  didSet {
		updateNumberOfWeeks()
	  }
	}

	// MARK: - Initialization

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBar()
		setupDelegates()
		updateNumberOfWeeks()
		setupDayFormatter()
		setupDataSource()
		applySnapshot(todosBySection)
		rootView.calendarHeaderView.baseDate = baseDate
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {

		let createButton = UIBarButtonItem(
			title: "New Task +",
			style: .plain,
			target: self,
			action: #selector(createButtonTapped))

		createButton.tintColor = .white
		navigationItem.rightBarButtonItem = createButton
	}

	// MARK: Implement new task creation

	@objc private func createButtonTapped() {
//		let taskScreen = TaskScreenViewController()
//		navigationController?.pushViewController(taskScreen,
//												 animated: true)
	}

	private func setupDelegates() {
		rootView.calendarFooterView.delegate = self
		rootView.calendarCollectionView.dataSource = self
		rootView.calendarCollectionView.delegate = self
		rootView.tasksTableView.delegate = self
	}

	private func setupDayFormatter() {
		dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d"
	}

	private func updateNumberOfWeeks() {
		let calendar = dateService.calendar
		numberOfWeeksInBaseDate = calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
	}

	private func updateDaysAndReloadCollectionView() {
		// Regenerate days array
		days = generateDaysInMonth(for: baseDate)
		// Reload collection view data
		rootView.calendarCollectionView.reloadData()
		// Update header with current month
		rootView.calendarHeaderView.baseDate = baseDate
	}
}

// MARK: - Day Generation

private extension MainViewController {

	// Get actual data for month
	func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
		guard let numberOfDaysInMonth = dateService.calendar.range(
			of: .day,
			in: .month,
			for: baseDate)?.count,
			  let firstDayOfMonth = dateService.calendar.date(
				from: dateService.calendar.dateComponents([.year, .month], from: baseDate)
			  )
		else {
			throw CalendarDataError.metadataGeneration
		}

		let firstDayWeekday = dateService.calendar.component(.weekday, from: firstDayOfMonth)

		return MonthMetadata(
			numberOfDays: numberOfDaysInMonth,
			firstDay: firstDayOfMonth,
			firstDayWeekday: firstDayWeekday
		)
	}

	func generateDaysInMonth(for baseDate: Date) -> [Day] {
		guard let metadata = try? monthMetadata(for: baseDate) else {
			fatalError("An error occurred when generating the metadata for \(baseDate)")
		}

		let numberOfDaysInMonth = metadata.numberOfDays
		let offsetInInitialRow = metadata.firstDayWeekday
		let firstDayOfMonth = metadata.firstDay

		// code to avoid gaps in a month's first row
		var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
				let isWithinDisplayedMonth = day >= offsetInInitialRow
				let dayOffset =
				isWithinDisplayedMonth ?
				day - offsetInInitialRow :
				-(offsetInInitialRow - day)

				return generateDay(
					offsetBy: dayOffset,
					for: firstDayOfMonth,
					isWithinDisplayedMonth: isWithinDisplayedMonth
				)
			}
		days += generateStartOfNextMonth(using: firstDayOfMonth)

		return days
	}

	func generateDay(
		offsetBy dayOffset: Int,
		for baseDate: Date,
		isWithinDisplayedMonth: Bool
	) -> Day {
		let date = dateService.calendar.date(
			byAdding: .day,
			value: dayOffset,
			to: baseDate)
		?? baseDate

		// An error here
		return Day(
			date: date,
			number: dateFormatter.string(from: date),
			isSelected: dateService.calendar.isDate(date, inSameDayAs: selectedDate ?? Date()),
			isWithinDisplayedMonth: isWithinDisplayedMonth
		)
	}

	func generateStartOfNextMonth(
		using firstDayOfDisplayedMonth: Date
	) -> [Day] {
		guard
			let lastDayInMonth = dateService.calendar.date(
				byAdding: DateComponents(month: 1, day: -1),
				to: firstDayOfDisplayedMonth
			)
		else {
			return []
		}

		let additionalDays = 7 - dateService.calendar.component(.weekday, from: lastDayInMonth)
		guard additionalDays > 0 else {
			return []
		}

		let days: [Day] = (1...additionalDays)
			.map {
				generateDay(
					offsetBy: $0,
					for: lastDayInMonth,
					isWithinDisplayedMonth: false)
			}

		return days
	}


	enum CalendarDataError: Error {
		case metadataGeneration
	}
}

// MARK: - CalendarScreenFooterViewDelegate

extension MainViewController: CalendarFooterViewDelegate {

	func previousMonthButtonTapped() {
		baseDate = dateService.calendar.date(
		  byAdding: .month,
		  value: -1,
		  to: baseDate
		  ) ?? baseDate

		updateDaysAndReloadCollectionView()
	}

	func nextMonthButtonTapped() {
		baseDate = dateService.calendar.date(
		  byAdding: .month,
		  value: 1,
		  to: baseDate
		  ) ?? baseDate

		updateDaysAndReloadCollectionView()
	}

}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		days.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let day = days[indexPath.row]

		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: CalendarCell.reuseIdentifier,
			for: indexPath) as! CalendarCell

		cell.day = day
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath
	) {
		let day = days[indexPath.row]
		selectedDate = day.date
		print(selectedDate)
		// MARK: place to get tasks for selected date
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let width = Int(collectionView.frame.width / 7)
		let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
		return CGSize(width: width, height: height)
	}
}

// MARK: - UIDiffableDataSource

extension MainViewController {

	private func setupDataSource() {
		   dataSource = UITableViewDiffableDataSource<HourSection, ToDo>(tableView: rootView.tasksTableView) { (tableView, indexPath, todo) -> UITableViewCell? in

			   guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for:indexPath) as? ToDoCell else {
				   return UITableViewCell()
			   }

			   cell.configure(with: todo)
			   return cell
		   }

	   }

	   func applySnapshot(_ itemsBySection:[HourSection:[ToDo]]) {
		   var snapshot = NSDiffableDataSourceSnapshot<HourSection, ToDo>()

		   for section in HourSection.allCases {
			   snapshot.appendSections([section])
			   let items = itemsBySection[section] ?? []
			   snapshot.appendItems(items, toSection: section)
		   }

		   dataSource.apply(snapshot, animatingDifferences:true)
	   }
	}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HourHeaderView") as? HourHeaderView else {
			return UITableViewHeaderFooterView()
		}
		   header.configure(with: HourSection(rawValue: section)?.title ?? "")
		   return header
	   }
	}

