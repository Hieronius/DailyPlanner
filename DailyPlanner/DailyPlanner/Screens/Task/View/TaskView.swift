import UIKit

/// A protocol that defines methods for responding to events in the `TaskView`.
protocol TaskViewDelegate: AnyObject {

	/// Called when the done button is tapped.
	func doneButtonTapped()

	/// Called when the value of the start date picker has changed.
	func startDatePickerValueBeenChanged()
}

/// A custom view for managing task details.
final class TaskView: UIView {

	// MARK: - Public Properties

	/// The delegate that receives events from the task view.
	weak var delegate: TaskViewDelegate?
	
	let containerView = UIView()
	let stackView = UIStackView()

	let topSpacer = UIView()

	let titleLabel = UILabel()
	let titleTextField = CustomTextField()

	let titleSpacer = UIView()

	let descriptionLabel = UILabel()
	let descriptionTextField = CustomTextField()

	let descriptionSpacer = UIView()

	let startDateLabel = UILabel()
	let startDatePicker = UIDatePicker()

	let startDateSpacer = UIView()

	let endDateLabel = UILabel()
	let endDatePicker = UIDatePicker()

	let endDateSpacer = UIView()

	let doneLabel = UILabel()
	let doneSwitch = UISwitch()

	let bottomSpacer = UIView()

	let doneButton = UIButton()

	// MARK: - Initialization

	/// This initializer sets up the views, layout, appearance, and initial data for the task view.
	init() {
		super.init(frame: .zero)

		embedViews()
		setupLayout()
		setupAppearance()
		setupData()
		setupDoneButton()
		setupStartDatePicker()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private Methods

// MARK: - Embed Views

private extension TaskView {

	func embedViews() {

		addSubview(containerView)

		containerView.addSubview(stackView)

		stackView.addArrangedSubview(topSpacer)

		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(titleTextField)

		stackView.addArrangedSubview(titleSpacer)

		stackView.addArrangedSubview(descriptionLabel)
		stackView.addArrangedSubview(descriptionTextField)

		stackView.addArrangedSubview(descriptionSpacer)

		stackView.addArrangedSubview(startDateLabel)
		stackView.addArrangedSubview(startDatePicker)

		stackView.addArrangedSubview(startDateSpacer)

		stackView.addArrangedSubview(endDateLabel)
		stackView.addArrangedSubview(endDatePicker)

		stackView.addArrangedSubview(endDateSpacer)

		stackView.addArrangedSubview(doneLabel)
		stackView.addArrangedSubview(doneSwitch)

		stackView.addArrangedSubview(bottomSpacer)

		addSubview(doneButton)
	}
}

// MARK: - Setup Layout

private extension TaskView {

	func setupLayout() {

		containerView.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		doneButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([

			containerView.topAnchor.constraint(equalTo:
												safeAreaLayoutGuide.topAnchor),
			containerView.leadingAnchor.constraint(equalTo:
													safeAreaLayoutGuide.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo:
														safeAreaLayoutGuide.trailingAnchor),
			containerView.heightAnchor.constraint(equalTo:
													heightAnchor, multiplier: 0.7),

			stackView.topAnchor.constraint(equalTo:
											containerView.topAnchor, constant: 10),
			stackView.leadingAnchor.constraint(equalTo:
												containerView.leadingAnchor, constant: 10),
			stackView.trailingAnchor.constraint(equalTo:
													containerView.trailingAnchor, constant: -10),
			stackView.bottomAnchor.constraint(equalTo:
												containerView.bottomAnchor, constant: -10),

			topSpacer.heightAnchor.constraint(lessThanOrEqualToConstant: 20),

			titleSpacer.heightAnchor.constraint(equalToConstant: 10),

			titleTextField.widthAnchor.constraint(equalTo:
													stackView.widthAnchor),
			titleTextField.heightAnchor.constraint(equalToConstant: 35),

			descriptionSpacer.heightAnchor.constraint(equalToConstant: 10),

			descriptionTextField.widthAnchor.constraint(equalTo:
															stackView.widthAnchor),
			descriptionTextField.heightAnchor.constraint(equalToConstant: 35),

			startDatePicker.heightAnchor.constraint(lessThanOrEqualToConstant: 40),

			startDateSpacer.heightAnchor.constraint(equalToConstant: 10),

			endDatePicker.heightAnchor.constraint(lessThanOrEqualToConstant: 40),

			endDateSpacer.heightAnchor.constraint(equalToConstant: 10),

			bottomSpacer.heightAnchor.constraint(lessThanOrEqualToConstant: 20),

			doneButton.bottomAnchor.constraint(equalTo:
												safeAreaLayoutGuide.bottomAnchor),
			doneButton.leadingAnchor.constraint(equalTo:
													safeAreaLayoutGuide.leadingAnchor),
			doneButton.trailingAnchor.constraint(equalTo:
													safeAreaLayoutGuide.trailingAnchor),
			doneButton.heightAnchor.constraint(equalToConstant: 50)
		])
	}
}

// MARK: - Setup Appearance

private extension TaskView {

	func setupAppearance() {

		backgroundColor = .systemBackground

		containerView.backgroundColor = .systemGray6

		containerView.layer.cornerRadius = 15
		containerView.clipsToBounds = true

		stackView.axis = .vertical
		stackView.distribution = .equalSpacing
		stackView.alignment = .leading
		stackView.spacing = 5

		titleLabel.font = .systemFont(ofSize: 20, weight: .bold)

		setupCustomPlaceholder(titleTextField)
		titleTextField.backgroundColor = .systemGray5
		titleTextField.layer.cornerRadius = 10
		titleTextField.clipsToBounds = true

		descriptionLabel.font = .systemFont(ofSize: 20, weight: .bold)

		setupCustomPlaceholder(descriptionTextField)
		descriptionTextField.backgroundColor = .systemGray5
		descriptionTextField.layer.cornerRadius = 10
		descriptionTextField.clipsToBounds = true

		startDateLabel.font = .systemFont(ofSize: 20, weight: .bold)

		startDatePicker.preferredDatePickerStyle = .compact
		startDatePicker.calendar = Calendar(identifier: .gregorian)
		startDatePicker.locale = Locale(identifier: "en_GB")
		startDatePicker.tintColor = .systemRed

		endDateLabel.font = .systemFont(ofSize: 20, weight: .bold)

		endDatePicker.preferredDatePickerStyle = .compact
		endDatePicker.calendar = Calendar(identifier: .gregorian)
		endDatePicker.locale = Locale(identifier: "en_GB")
		endDatePicker.isUserInteractionEnabled = false

		doneLabel.font = .systemFont(ofSize: 20, weight: .bold)

		doneSwitch.onTintColor = .systemRed

		doneButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
		doneButton.backgroundColor = .systemRed
		doneButton.layer.cornerRadius = 10
		doneButton.clipsToBounds = true
	}
}

// MARK: - Setup Data

private extension TaskView {

	func setupData() {

		titleLabel.text = "Task title"

		descriptionLabel.text = "Task description"

		startDateLabel.text = "Start date"
		startDatePicker.date = .now

		endDateLabel.text = "End date"

		endDatePicker.date = startDatePicker.date.addingTimeInterval(3600)

		doneLabel.text = "Completed"

		doneButton.setTitle("Done", for: .normal)
	}

	func setupCustomPlaceholder(_ textField: UITextField) {

		let placeholderText = "Enter your text here"
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.lightGray,
			.font: UIFont.systemFont(ofSize: 16)
		]
		textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
	}
}

// MARK: - Actions

private extension TaskView {

	func setupDoneButton() {

		doneButton.addTarget(self,
							 action: #selector(didDoneButtonTapped),
							 for: .touchUpInside)
	}

	@objc func didDoneButtonTapped() {
		delegate?.doneButtonTapped()
	}

	func setupStartDatePicker() {

		startDatePicker.addTarget(self,
								  action: #selector(startDatePickerValueBeenChanged),
								  for: .valueChanged)
	}

	@objc func startDatePickerValueBeenChanged() {
		delegate?.startDatePickerValueBeenChanged()
	}
}
