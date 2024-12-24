import UIKit

/// A view controller that manages the main interface for the calendar and task list.
final class MainViewController: GenericViewController<MainView> {
	
	// MARK: - Public Properties
	
	/// Selected date on the calendar to load existing tasks
	var selectedDate = Date()
	
	/// An exact position of selected date on the screen
	var selectedDateCellIndexPath: IndexPath?
	
	/// An array of tasks visible for the selected date.
	var dailyVisibleTasks: [ToDo] = []
	
	// MARK: - Private Properties
	
	private let dataManager: RealmDataManagerProtocol
	private let jsonHandler: JSONHandlerProtocol
	private var calendarGenerator: CalendarGeneratorProtocol
	
	private var isInitialAppLaunch = true
	
	private var dataSource: UITableViewDiffableDataSource<Int, ToDo>!
	
	
	// MARK: - Initialization

	/// Initializes a new instance of `MainViewController`.
	///
	/// - Parameters:
	///   - dataManager: The data manager used for interacting with Realm storage.
	///   - jsonHandler: The handler used for managing JSON data operations.
	///   - calendarGenerator: The generator used for creating calendar views.
	init(dataManager: RealmDataManagerProtocol,
		 jsonHandler: JSONHandlerProtocol,
		 calendarGenerator: CalendarGeneratorProtocol) {
		
		self.dataManager = dataManager
		self.jsonHandler = jsonHandler
		self.calendarGenerator = calendarGenerator
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
		setupDataSource()
		updateCalendar()
		selectInitialDate()
		
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
}

// MARK: - Private Methods

// MARK: Setup Delegates

private extension MainViewController {

	func setupDelegates() {

		rootView.calendarFooterView.delegate = self
		rootView.calendarCollectionView.dataSource = self
		rootView.calendarCollectionView.delegate = self
		rootView.tasksTableView.delegate = self
	}
}

// MARK: - Setup Navigation Bar

private extension MainViewController {

	func setupNavigationBar() {

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

	@objc func showOptionsMenu() {

		let alertController = UIAlertController(title: nil,
												message: nil,
												preferredStyle: .actionSheet)

		let shareAction = UIAlertAction(title: "Share tasks",
										style: .default) { action in
			self.shareTasks()
		}
		alertController.addAction(shareAction)

		let importAction = UIAlertAction(title: "Import tasks",
										 style: .default) { action in
			self.importTasks()
		}
		alertController.addAction(importAction)

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


	@objc func createButtonTapped() {

		let taskScreen = TaskViewController(screenMode: .newTask,
											dataManager: dataManager)
		navigationController?.pushViewController(taskScreen,
												 animated: true)
	}

	func shareTasks() {

		let tasksToShare = dataManager.getAllTasks()

		do {
			try jsonHandler.saveTodosToFile(tasksToShare, filename: "Tasks.json")
		} catch {
			print("Failed to encode tasks for sharing \(error.localizedDescription)")
		}
	}

	func importTasks() {

		do {
			let tasksToImport = try jsonHandler.loadTodosFromFile(filename: "Tasks.json")
			dataManager.saveAllTasks(tasksToImport)
			dailyVisibleTasks = dataManager.loadDailyTasks(date: selectedDate)
			applySnapshot()
		} catch {
			print("Failed to decode tasks from import \(error.localizedDescription)")
		}
	}
}

// MARK: Setup Initial Tasks

private extension MainViewController {

	func selectInitialDate() {
		
		if let todayIndex = calendarGenerator.generateDaysInMonth().firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
			
			let todayIndexPath = IndexPath(row: todayIndex, section: 0)
			collectionView(rootView.calendarCollectionView, didSelectItemAt: todayIndexPath)
		}
	}

	func updateCalendar() {

		rootView.calendarCollectionView.reloadData()
		rootView.calendarHeaderView.baseDate = calendarGenerator.baseDate
		dailyVisibleTasks = dataManager.loadDailyTasks(date: selectedDate)
		applySnapshot()
	}

	func groupTasksByHour(todos: [ToDo]) -> [Int: [ToDo]] {
		
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
}

// MARK: - UIDiffableDataSource

private extension MainViewController {

	func setupDataSource() {
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

// MARK: - CalendarScreenFooterViewDelegate

extension MainViewController: CalendarFooterViewDelegate {
	
	func previousMonthButtonTapped() {
		calendarGenerator.baseDate = calendarGenerator.dateService.calendar.date(
			byAdding: .month,
			value: -1,
			to: calendarGenerator.baseDate
		) ?? calendarGenerator.baseDate
		
		updateCalendar()
	}
	
	func nextMonthButtonTapped() {
		calendarGenerator.baseDate = calendarGenerator.dateService.calendar.date(
			byAdding: .month,
			value: 1,
			to: calendarGenerator.baseDate
		) ?? calendarGenerator.baseDate
		
		updateCalendar()
	}
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
		return calendarGenerator.generateDaysInMonth().count
	}
	
	func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath : IndexPath) -> UICollectionViewCell {

		let day = calendarGenerator.generateDaysInMonth()[indexPath.row]
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier : CalendarCell.reuseIdentifier, for : indexPath) as! CalendarCell
		
		cell.day = day
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView:UICollectionView, didSelectItemAt indexPath : IndexPath) {
		
		if let previousIndexPath = selectedDateCellIndexPath {
			if let previousCell = collectionView.cellForItem(at : previousIndexPath) as? CalendarCell {
				previousCell.isSelectedCell = false
			}
		}
		
		let day = calendarGenerator.generateDaysInMonth()[indexPath.row]
		selectedDate = day.date
		selectedDateCellIndexPath = indexPath
		
		if let currentCell = collectionView.cellForItem(at: indexPath) as? CalendarCell {
			currentCell.isSelectedCell = true
		}
		
		dailyVisibleTasks = dataManager.loadDailyTasks(date:selectedDate)
		applySnapshot()
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {

		let width = Int(collectionView.frame.width / 7)
		let height = Int(collectionView.frame.height) / calendarGenerator.numberOfWeeksInBaseDate
		return CGSize(width: width, height: height)
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
			
			let deleteAction = UIAction(title: "Delete", attributes: .destructive) { action in
				guard let indexToDelete = self.dailyVisibleTasks.firstIndex(of:selectedTask) else {
					return
				}
				self.dailyVisibleTasks.remove(at: indexToDelete)
				self.dataManager.deleteTask(selectedTask)
				self.applySnapshot()
			}
			
			return UIMenu(title: "", children: [deleteAction])
		}
	}
}
