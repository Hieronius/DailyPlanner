import UIKit

final class TaskViewController: GenericViewController<TaskView> {

	// MARK: - Public Properties

	var screenMode: TaskScreenMode
	var displayedTask: ToDo? // may be try didSet/WillGet
	// how to pass UUID of the task here and load task from Realm?

	// MARK: - Private Properties

	private let dataManager: RealmDataManagerProtocol

	// MARK: - Initialization

	init(screenMode: TaskScreenMode,
		 dataManager: RealmDataManagerProtocol) {
		self.screenMode = screenMode
		self.dataManager = dataManager
		super.init(nibName: nil, bundle: nil)
		// setup View accordingly
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBar()
		rootView.delegate = self
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		navigationController?.navigationBar.tintColor = .white
	}

}

extension TaskViewController: TaskViewDelegate {

	func doneButtonTapped() {
		// collect data for new task or update an old task and load it to the Realm Data Storage

		/*
		 let newTask = ToDo(id, title, description, startDate, endDate, isCompleted)
		 Realm.update/save
		 navigationController.pop()
		 */
	}


}
