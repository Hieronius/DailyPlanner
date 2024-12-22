import UIKit

final class TaskViewController: GenericViewController<TaskView> {

	// MARK: - Public Properties

	private var screenMode: TaskScreenMode
	var displayedTask: ToDo?

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
		setupViewToDismissKeyboard()
		prepareScreenBasedOnMode()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		navigationController?.navigationBar.tintColor = .white
	}

	private func prepareScreenBasedOnMode() {

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

extension TaskViewController {

	func setupViewToDismissKeyboard() {
	// Add tap gesture recognizer to dismiss keyboard
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
			view.addGestureRecognizer(tapGesture)
		}

		// MARK: - Dismiss Keyboard Function
		@objc private func dismissKeyboard() {
			view.endEditing(true)
		}
}

extension TaskViewController: TaskViewDelegate {

	func doneButtonTapped() {
		print("button tapped")

		switch screenMode {

		case .newTask:

			let newTask = ToDo(id: UUID(),
							   title: rootView.titleTextField.text ?? "",
							   description: rootView.descriptionTextField.text ?? "",
							   startDate: rootView.startDatePicker.date,
							   endDate: rootView.endDatePicker.date,
							   isCompleted: rootView.doneSwitch.isOn)

			dataManager.saveOrUpdateTask(newTask)
			print("saved \(newTask)")
			navigationController?.popViewController(animated: true)

		case .detail(id: let id):

				let existingTask = ToDo(id: id,
										title: rootView.titleTextField.text ?? "",
										description: rootView.descriptionTextField.text ?? "",
										startDate: rootView.startDatePicker.date,
										endDate: rootView.endDatePicker.date,
										isCompleted: rootView.doneSwitch.isOn)

				dataManager.saveOrUpdateTask(existingTask)
				print("updated \(existingTask)")
				navigationController?.popViewController(animated: true)
			}

		}

		func startDatePickerValueBeenChanged() {
			rootView.endDatePicker.date = rootView.startDatePicker.date.addingTimeInterval(3600)
		}


	}
