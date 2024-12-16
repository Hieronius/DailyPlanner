import UIKit

final class TaskView: UIView {

	// back button should do nothing (don't forget about color)

	// add spacing to stack view for smooth gaps between elements

	let containerView = UIView()
	let stackView = UIStackView() // may be i need a few internal stacks
	let titleLabel = UILabel()
	let titleTextField = UITextField() // can be empty
	let descriptionLabel = UILabel()
	let descriptionTextField = UITextField() // can be empty
	let startDateLabel = UILabel()
	let startDatePicker = UIDatePicker() // .now() by default
	let endDateLabel = UILabel()
	let endDateTextField = UITextField() // +1 hour of the start date
	let doneLabel = UILabel()
	let doneSwitch = UISwitch() // Detail
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

		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(titleTextField)
		stackView.addArrangedSubview(descriptionLabel)
		stackView.addArrangedSubview(descriptionTextField)
		stackView.addArrangedSubview(startDateLabel)
		stackView.addArrangedSubview(startDatePicker)
		stackView.addArrangedSubview(endDateLabel)
		stackView.addArrangedSubview(endDateTextField)
		stackView.addArrangedSubview(doneLabel)
		stackView.addArrangedSubview(doneSwitch)

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
		stackView.spacing = 5

		doneButton.tintColor = .white
		doneButton.backgroundColor = .systemRed
		doneButton.layer.cornerRadius = 10
		doneButton.clipsToBounds = true

	}

	private func setupData() {

		titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
		titleLabel.text = "Task title"

//		titleTextField.tintColor = .gray // tint color does not work
		titleTextField.text = "Title Example"

		descriptionLabel.font = .systemFont(ofSize: 20, weight: .bold)
		descriptionLabel.text = "Task description"

		descriptionTextField.tintColor = .gray
		descriptionTextField.text = ""

		startDateLabel.font = .systemFont(ofSize: 20, weight: .bold)
		startDateLabel.text = "Start date"
		startDatePicker.date = .now

		endDateLabel.font = .systemFont(ofSize: 20, weight: .bold)
		endDateLabel.text = "End date"

		endDateTextField.tintColor = .gray
		endDateTextField.text = "\(startDatePicker.date.addingTimeInterval(3600))"

		doneLabel.font = .systemFont(ofSize: 20, weight: .bold)
		doneLabel.text = "Completed"

		doneButton.setTitle("Done", for: .normal)
		doneButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
	}

}
