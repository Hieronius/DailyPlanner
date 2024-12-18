import UIKit

final class MainViewController: GenericViewController<MainView> {

	// MARK: - Public Properties

	/// Selected date on the calendar to load existing tasks
	var selectedDate = Date()

	/// An exact position of selected date on the screen
	var selectedDateCellIndexPath: IndexPath?

	/// List of tasks filtered by it's hour time stamp
	var todosBySection: [HourSection: [ToDo]] = [

		.hour0: [ToDo(id: UUID(), title: "Task 1", description: "Description 1", startDate: .now, endDate: .now, isCompleted: false),

				 ToDo(id: UUID(), title: "Task 1.1", description: "Description 1.1", startDate: .now, endDate: .now, isCompleted: false),

				 ToDo(id: UUID(), title: "Task 1.2", description: "Description 1.2", startDate: .now, endDate: .now, isCompleted: false),
				 
				 ToDo(id: UUID(), title: "Task 1.3", description: "Description 1.3", startDate: .now, endDate: .now, isCompleted: false)],

		.hour1: [ToDo(id: UUID(), title: "Task 2", description: "Description 2", startDate: .now, endDate: .now, isCompleted: false)]
	]

	// MARK: - Private Properties

	private let dataManager: RealmDataManagerProtocol

	private lazy var days = generateDaysInMonth(for: baseDate)
	private var dateFormatter: DateFormatter!
	private let dateService = DateService.shared
	private var numberOfWeeksInBaseDate = 0

	private var dataSource: UITableViewDiffableDataSource<HourSection, ToDo>!


	private var baseDate: Date = Date() {
	  didSet {
		updateNumberOfWeeks()
	  }
	}

	// MARK: - Initialization

	init(dataManager: RealmDataManagerProtocol) {
		self.dataManager = dataManager
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle

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

	private func filterToDosByHour(todos: [ToDo], hour: Int) -> [ToDo] {

		let calendar = Calendar.current

		let filteredTasks = todos.filter { todo in

			guard let startDate = todo.startDate else { return false }
			let components = calendar.dateComponents([.hour], from: startDate)
			return components.hour == hour
		}

		return filteredTasks
	}

	// MARK: - Setup Navigation Bar

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
		let taskScreen = TaskViewController(screenMode: .newTask, dataManager: dataManager)
		navigationController?.pushViewController(taskScreen,
												 animated: true)
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

		// Set selected date to today if it's nil
		if selectedDate == nil {
			selectedDate = Date()
			selectedDateCellIndexPath = IndexPath(row: days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) ?? 0, section: 0)
			days[selectedDateCellIndexPath?.row ?? 0].isSelected = true
		}

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

		// Find and set today's index path if it matches the base date
			if Calendar.current.isDate(baseDate, inSameDayAs: Date()) {
				if let todayIndex = days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
					selectedDateCellIndexPath = IndexPath(row: todayIndex, section: 0)
				}
			}
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

		// Deselect previous cell if any
			if let previousIndexPath = selectedDateCellIndexPath {
				if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CalendarCell {
					previousCell.isSelectedCell = false
				}
			}

			// Select new cell
			guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
			cell.isSelectedCell = true

			// Update selected date and index path
			let day = days[indexPath.row]
			selectedDate = day.date
			selectedDateCellIndexPath = indexPath

		// MARK: Fetch tasks from Realm and pass to DataSource via local array of tasks

			print(selectedDate ?? "No date selected")
		print(selectedDateCellIndexPath)
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

