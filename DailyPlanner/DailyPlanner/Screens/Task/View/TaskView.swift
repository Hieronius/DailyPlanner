import UIKit

final class TaskView: UIView {

	// back button should do nothing (don't forget about color)

	// add spacing to stack view for smooth gaps between elements

	let containerView = UIView()
	let stackView = UIStackView() // may be i need a few internal stacks

	let topSpacer = UIView()

	let titleLabel = UILabel()
	let titleTextField = CustomTextField() // can be empty // add background text/color

	let titleSpacer = UIView()

	let descriptionLabel = UILabel()
	let descriptionTextField = CustomTextField() // can be empty

	let descriptionSpacer = UIView()

	let startDateLabel = UILabel()
	let startDatePicker = UIDatePicker() // .now() by default // change tint color

	let startDateSpacer = UIView()

	let endDateLabel = UILabel()
	let endDatePicker = UIDatePicker() // +1 hour of the start date // change to date picker

	let endDateSpacer = UIView()

	let doneLabel = UILabel()
	let doneSwitch = UISwitch() // Detail

	let bottomSpacer = UIView()

	let doneButton = UIButton() // Done/Create

	// MARK: - Initialization

	init() {
		super.init(frame: .zero)

		embedViews()
		setupLayout()
		setupAppearance()
		setupData()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func embedViews() {

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

	private func setupLayout() {

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
													heightAnchor, multiplier: 0.6),

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

	private func setupAppearance() {

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
		descriptionTextField.text

		startDateLabel.font = .systemFont(ofSize: 20, weight: .bold)

		startDatePicker.preferredDatePickerStyle = .compact

		endDateLabel.font = .systemFont(ofSize: 20, weight: .bold)

		endDatePicker.preferredDatePickerStyle = .compact
		endDatePicker.isUserInteractionEnabled = false

		doneLabel.font = .systemFont(ofSize: 20, weight: .bold)

		doneButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
		doneButton.backgroundColor = .systemRed
		doneButton.layer.cornerRadius = 10
		doneButton.clipsToBounds = true

	}

	private func setupData() {

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

		// Set attributed placeholder
		let placeholderText = "Enter your text here"
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.lightGray, // Placeholder color
			.font: UIFont.systemFont(ofSize: 16) // Placeholder font size
		]
		textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
	}

}
