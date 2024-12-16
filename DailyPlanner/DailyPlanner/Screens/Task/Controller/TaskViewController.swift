import UIKit

final class TaskViewController: GenericViewController<TaskView> {

	// MARK: - Public Propertied

	var screenMode: TaskScreenMode
	var displayedTask: ToDo? // may be try didSet/WillGet
	// how to pass UUID of the task here and load task from Realm?

	// MARK: - Initialization

	init(screenMode: TaskScreenMode) {
		self.screenMode = screenMode
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
