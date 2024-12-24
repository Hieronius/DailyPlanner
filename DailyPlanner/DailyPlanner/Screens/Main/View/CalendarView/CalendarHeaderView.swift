import UIKit

/// A custom view that displays the header for a calendar, including the current month
final class CalendarHeaderView: UIView {

	// MARK: - Public Properties

	/// A label that displays the current month of the year.
	var monthLabel: UILabel!

	/// A stack view that holds and distributes labels for the days of the week (e.g., M-T-W...).
	var dayOfWeekStackView: UIStackView!

	/// A separator view that visually divides the header from the calendar days below.
	var separatorView: UIView!

	/// Base date used for displaying month information.
	var baseDate = Date() {
		didSet {
			monthLabel.text = dateFormatter.string(from: baseDate)
		}
	}

	// MARK: - Private Properties

	/// A date formatter used for formatting date information into a readable string.
	private var dateFormatter: DateFormatter!


	// MARK: - Initialization

	/// Initializes a new instance of `CalendarHeaderView`.
	///
	/// This initializer sets up the view's components and configures their layout.
	init() {
		super.init(frame: CGRect.zero)

		setupViews()
		setupDateFormatter()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private Methods

private extension CalendarHeaderView {

	func setupViews() {

		setupHeaderView()
		setupHeaderConstraints()
	}

	func setupHeaderView() {

		backgroundColor = .systemGray6

		layer.maskedCorners = [
			.layerMinXMinYCorner,
			.layerMaxXMinYCorner
		]

		layer.cornerCurve = .continuous
		layer.cornerRadius = 15

		setupMonthLabel()
		setupDayOfWeekStackView()
		setupSeparatorView()
	}

	func setupMonthLabel() {

		monthLabel = UILabel()
		monthLabel.font = .systemFont(ofSize: 26, weight: .bold)
		monthLabel.text = "Month"

		addSubview(monthLabel)
	}

	func setupDayOfWeekStackView() {

		dayOfWeekStackView = UIStackView()
		dayOfWeekStackView.distribution = .fillEqually
		addSubview(dayOfWeekStackView)

		for dayNumber in 1...7 {
			let dayLabel = UILabel()
			dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
			dayLabel.textColor = .secondaryLabel
			dayLabel.textAlignment = .center
			dayLabel.text = dayOfWeekLetter(for: dayNumber)
			dayLabel.isAccessibilityElement = false
			dayOfWeekStackView.addArrangedSubview(dayLabel)
		}
	}

	func setupSeparatorView() {

		separatorView = UIView()
		separatorView.backgroundColor = UIColor.label.withAlphaComponent(0.2)

		addSubview(separatorView)
	}

	private func setupHeaderConstraints() {
		
		monthLabel.translatesAutoresizingMaskIntoConstraints = false
		dayOfWeekStackView.translatesAutoresizingMaskIntoConstraints = false
		separatorView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			monthLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
			monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
			monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
		])

		NSLayoutConstraint.activate([
			dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5)
		])

		NSLayoutConstraint.activate([
			separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
			separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
			separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 1)
		])
	}
}

// MARK: - Setup DateFormatter

private extension CalendarHeaderView {

	func setupDateFormatter() {

		dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .gregorian)
		dateFormatter.locale = Locale.autoupdatingCurrent
		dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
	}
}

// MARK: - Helper Methods

private extension CalendarHeaderView {

	/// Returns the abbreviated letter representation for the day of the week.
	/// - Parameter dayNumber: The numerical representation of the day of the week (1-7).
	/// - Returns: Abbreviated letter representation of the day of the week.
	func dayOfWeekLetter(for dayNumber: Int) -> String {

		switch dayNumber {
		case 1:
			return "S"
		case 2:
			return "M"
		case 3:
			return "T"
		case 4:
			return "W"
		case 5:
			return "T"
		case 6:
			return "F"
		case 7:
			return "S"
		default:
			return ""
		}
	}
}
