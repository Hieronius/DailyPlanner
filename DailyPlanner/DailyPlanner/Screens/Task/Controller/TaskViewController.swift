import UIKit

/// A view controller that manages the task creation and editing interface.
final class TaskViewController: GenericViewController<TaskView> {

	// MARK: - Private Properties

	private let dataManager: RealmDataManagerProtocol

	private var screenMode: TaskScreenMode
	private var displayedTask: ToDo?

	// MARK: - Initialization

	/// Initializes a new instance of `TaskViewController`.
	///
	/// - Parameters:
	///   - screenMode: The mode indicating whether to create a new task or edit an existing one.
	///   - dataManager: The data manager used for interacting with Realm storage.
	init(screenMode: TaskScreenMode,
		 dataManager: RealmDataManagerProtocol) {
		self.screenMode = screenMode
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
		rootView.delegate = self
		setupViewToDismissKeyboard()
		prepareScreenBasedOnMode()
	}
}

// MARK: - Private Methods

private extension TaskViewController {

	func setupNavigationBar() {
		navigationController?.navigationBar.tintColor = .white
	}
}

// MARK: - Setup initial screen state

private extension TaskViewController {

	func prepareScreenBasedOnMode() {

		switch screenMode {

		case .newTask:

			rootView.titleTextField.becomeFirstResponder()
			rootView.doneSwitch.isOn = false

		case .detail(id: let id):

			guard let displayedTask = dataManager.loadSelectedTask(id: id) else {
				print("Failed to load the task by ID")
				return
			}
			rootView.titleTextField.text = displayedTask.title
			rootView.descriptionTextField.text = displayedTask.description
			rootView.startDatePicker.date = displayedTask.startDate ?? .now
			rootView.endDatePicker.date = displayedTask.endDate ?? .now
			rootView.doneSwitch.isOn = displayedTask.isCompleted
		}
	}
}

// MARK: - Setup Editing Mode

private extension TaskViewController {

	func setupViewToDismissKeyboard() {

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tapGesture)
	}

	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}

// MARK: - TaskViewDelegate

extension TaskViewController: TaskViewDelegate {

	func doneButtonTapped() {

		switch screenMode {

		case .newTask:

			let newTask = ToDo(id: UUID(),
							   title: rootView.titleTextField.text ?? "",
							   description: rootView.descriptionTextField.text ?? "",
							   startDate: rootView.startDatePicker.date,
							   endDate: rootView.endDatePicker.date,
							   isCompleted: rootView.doneSwitch.isOn)

			dataManager.saveOrUpdateTask(newTask)
			navigationController?.popViewController(animated: true)

		case .detail(id: let id):

			let existingTask = ToDo(id: id,
									title: rootView.titleTextField.text ?? "",
									description: rootView.descriptionTextField.text ?? "",
									startDate: rootView.startDatePicker.date,
									endDate: rootView.endDatePicker.date,
									isCompleted: rootView.doneSwitch.isOn)

			dataManager.saveOrUpdateTask(existingTask)
			navigationController?.popViewController(animated: true)
		}
	}
	
	func startDatePickerValueBeenChanged() {

		rootView.endDatePicker.date = rootView.startDatePicker.date.addingTimeInterval(3600)
	}
}
