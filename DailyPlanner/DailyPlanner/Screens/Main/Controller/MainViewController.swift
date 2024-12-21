import UIKit

final class MainViewController: GenericViewController<MainView> {

	// MARK: - Public Properties

	/// Selected date on the calendar to load existing tasks
	var selectedDate = Date()

	/// An exact position of selected date on the screen
	var selectedDateCellIndexPath: IndexPath?

	/// Populate from Realm
	var dailyVisibleTasks: [ToDo] = []

	// MARK: - Private Properties

	private let dataManager: RealmDataManagerProtocol
	private let jsonHandler: JSONHandlerProtocol

	private var isInitialAppLaunch = true

	private lazy var days = generateDaysInMonth(for: baseDate)
	private var dateFormatter: DateFormatter!
	private let dateService = DateService.shared
	private var numberOfWeeksInBaseDate = 0

	private var dataSource: UITableViewDiffableDataSource<Int, ToDo>!


	private var baseDate: Date = Date() {
	  didSet {
		updateNumberOfWeeks()
	  }
	}

	// MARK: - Initialization

	init(dataManager: RealmDataManagerProtocol,
		 jsonHandler: JSONHandlerProtocol) {

		self.dataManager = dataManager
		self.jsonHandler = jsonHandler
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
		rootView.calendarHeaderView.baseDate = baseDate

		dailyVisibleTasks = dataManager.loadDailyTasks(date: selectedDate)
		applySnapshot()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)

		if !isInitialAppLaunch {
			dailyVisibleTasks = dataManager.loadDailyTasks(date: selectedDate)
			applySnapshot()
		}

		isInitialAppLaunch = false
	}

	// MARK: - Private Methods

	/// Method to filter tasks by it's start date and populate accordingly to result
	private func groupTasksByHour(todos: [ToDo]) -> [Int: [ToDo]] {

		var groupedTasks = [Int: [ToDo]]()
		let calendar = Calendar.current

		for todo in todos {
			guard let startDate = todo.startDate else { continue }
			let hour = calendar.component(.hour, from: startDate)

			if groupedTasks[hour] != nil {
				groupedTasks[hour]?.append(todo)
			} else {
				groupedTasks[hour] = [todo]
			}
		}

		return groupedTasks
	}

	// MARK: - Setup Navigation Bar

	private func setupNavigationBar() {

		let optionsButton = UIBarButtonItem(

			image: UIImage(systemName: "gear"),
			style: .plain,
			target: self,
			action: #selector(showOptionsMenu)
		)

		optionsButton.tintColor = .white
		navigationItem.leftBarButtonItem = optionsButton

		let createButton = UIBarButtonItem(

			title: "New Task +",
			style: .plain,
			target: self,
			action: #selector(createButtonTapped)
		)

		createButton.tintColor = .white
		navigationItem.rightBarButtonItem = createButton
	}

	@objc private func showOptionsMenu() {

		let alertController = UIAlertController(title: nil,
												message: nil,
												preferredStyle: .actionSheet)

		let shareAction = UIAlertAction(title: "Share tasks",
										style: .default) { action in
			self.shareTasks()
		}
		alertController.addAction(shareAction)

		let deleteAction = UIAlertAction(title: "Delete all tasks",
										 style: .destructive) { action in
			self.dataManager.deleteAllTasks()
			self.dailyVisibleTasks = []
			self.applySnapshot()
		}
		alertController.addAction(deleteAction)

		let cancelAction = UIAlertAction(title: "Cancel",
										 style: .cancel)
		alertController.addAction(cancelAction)

		present(alertController, animated: true)
	}


	@objc private func createButtonTapped() {

		let taskScreen = TaskViewController(screenMode: .newTask,
											dataManager: dataManager)
		navigationController?.pushViewController(taskScreen,
												 animated: true)
	}

	// MARK: Convert Tasks from Realm into JSON file and prepare to share

	private func shareTasks() {
		let tasksToShare = dataManager.getAllTasks()

		// allTasks.convertToJSON()
	}

	// MARK: Setup Controller

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

			if let previousIndexPath = selectedDateCellIndexPath {
				if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CalendarCell {
					previousCell.isSelectedCell = false
				}
			}

			guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
			cell.isSelectedCell = true


			let day = days[indexPath.row]
			selectedDate = day.date
			selectedDateCellIndexPath = indexPath

		// MARK: Fetch tasks from Realm and pass to DataSource via local array of tasks

			print(selectedDate ?? "No date selected")
			print(selectedDateCellIndexPath)
		dailyVisibleTasks = dataManager.loadDailyTasks(date: selectedDate)
		applySnapshot()
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
		   dataSource = UITableViewDiffableDataSource<Int, ToDo>(tableView: rootView.tasksTableView) { (tableView, indexPath, todo) -> UITableViewCell? in

			   guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for:indexPath) as? ToDoCell else {
				   return UITableViewCell()
			   }

			   cell.configure(with: todo)
			   return cell
		   }

	   }

	func applySnapshot() {
		let groupedTasks = groupTasksByHour(todos: dailyVisibleTasks)
		var snapshot = NSDiffableDataSourceSnapshot<Int, ToDo>()

		for hour in 0..<24 {
			snapshot.appendSections([hour])
			if let tasksForHour = groupedTasks[hour] {
				snapshot.appendItems(tasksForHour, toSection: hour)
			}
		}

		dataSource.apply(snapshot, animatingDifferences: true)
	}

	}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HourHeaderView.reuseIdentifier) as? HourHeaderView else {
			return UITableViewHeaderFooterView()
		}

		header.configure(with: String(format: "%02d:00", section))
		return header
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		guard let selectedTask = dataSource.itemIdentifier(for: indexPath) else { return }

		let detailedScreen = TaskViewController(screenMode: .detail(id: selectedTask.id),
												dataManager: dataManager)

		navigationController?.pushViewController(detailedScreen, animated: true)
	}

	func tableView(_ tableView: UITableView,
					   contextMenuConfigurationForRowAt indexPath: IndexPath,
					   point: CGPoint) -> UIContextMenuConfiguration? {

		guard let selectedTask = dataSource.itemIdentifier(for: indexPath) else { return UIContextMenuConfiguration() }

			return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

				// Create delete action
				let deleteAction = UIAction(title: "Delete", attributes: .destructive) { action in
					guard let indexToDelete = self.dailyVisibleTasks.firstIndex(of:selectedTask) else {
						return
					}
					self.dailyVisibleTasks.remove(at: indexToDelete)
					self.dataManager.deleteTask(selectedTask)
					self.applySnapshot()
				}

				// Create other actions if needed

				return UIMenu(title: "", children: [deleteAction])
			}
		}
}


