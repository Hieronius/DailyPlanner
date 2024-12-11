import UIKit

final class CalendarHeaderView: UIView {

	// MARK: - Public Properties

	var monthLabel: UILabel!
	var dayOfWeekStackView: UIStackView!
	var separatorView: UIView!

	/// Base date used for displaying month information.
	var baseDate = Date() {
		didSet {
			monthLabel.text = dateFormatter.string(from: baseDate)
			print("change header")
		}
	}

	/// Date formatter for formatting date information.
	private var dateFormatter: DateFormatter!


	// MARK: - Initialization

	init() {
		super.init(frame: CGRect.zero)

		setupViews()
		setupDateFormatter()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupViews() {
		setupHeaderView()
		setupHeaderConstraints()
	}

	private func setupHeaderView() {
		backgroundColor = .systemGray6

		// Set the masked corners of the layer to the top-left and top-right corners to create rounded corners.
		layer.maskedCorners = [
			.layerMinXMinYCorner,
			.layerMaxXMinYCorner
		]

		// Set the corner curve to continuous to make the corners smooth.
		layer.cornerCurve = .continuous

		layer.cornerRadius = 15

		setupMonthLabel()
		setupDayOfWeekStackView()
		setupSeparatorView()

	}

	private func setupMonthLabel() {
		monthLabel = UILabel()
		monthLabel.font = .systemFont(ofSize: 26, weight: .bold)
		monthLabel.text = "Month"
		monthLabel.accessibilityTraits = .header
		monthLabel.isAccessibilityElement = true

		addSubview(monthLabel)
	}

	private func setupDayOfWeekStackView() {
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

	private func setupSeparatorView() {
		separatorView = UIView()
		separatorView.backgroundColor = UIColor.label.withAlphaComponent(0.2)

		addSubview(separatorView)
	}

	private func setupDateFormatter() {
		dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .gregorian)
		dateFormatter.locale = Locale.autoupdatingCurrent
		dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
	}

	private func setupHeaderConstraints() {
		// Enable Auto Layout for each view
		monthLabel.translatesAutoresizingMaskIntoConstraints = false
		dayOfWeekStackView.translatesAutoresizingMaskIntoConstraints = false
		separatorView.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for monthLabel
		NSLayoutConstraint.activate([
			monthLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
			monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
			monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
		])

		// Add constraints for dayOfWeekStackView
		NSLayoutConstraint.activate([
			dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5)
		])

		// Add constraints for separatorView
		NSLayoutConstraint.activate([
			separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
			separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
			separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 1)
		])
	}

	// MARK: - Helper Methods

	/// Returns the abbreviated letter representation for the day of the week.
	/// - Parameter dayNumber: The numerical representation of the day of the week (1-7).
	/// - Returns: Abbreviated letter representation of the day of the week.
	private func dayOfWeekLetter(for dayNumber: Int) -> String {
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
