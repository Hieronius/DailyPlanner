import UIKit

/// A protocol that defines methods for responding to calendar footer events.
protocol CalendarFooterViewDelegate: AnyObject {

	/// Called when the previous month button is tapped.
	func previousMonthButtonTapped()

	/// Called when the next month button is tapped.
	func nextMonthButtonTapped()
}

/// A custom view that serves as the footer for a calendar.
final class CalendarFooterView: UIView {

	// MARK: - Public Properties

	/// A delegate that receives events from the footer view.
	weak var delegate: CalendarFooterViewDelegate?

	/// A separator view that visually divides the footer from other content.
	var separatorView: UIView!

	/// A button that allows the user to navigate to the previous month.
	var previousMonthButton: UIButton!

	/// A button that allows the user to navigate to the next month.
	var nextMonthButton: UIButton!

	// MARK: - Initialization

	/// This initializer sets up the footer view and its components.
	init() {
		super.init(frame: .zero)

		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private Methods

private extension CalendarFooterView {

	// MARK: - UI

	func setupViews() {

		setupFooterView()
		setupSeparatorView()
		setupPreviousMonthButton()
		setupNextMonthButton()
	}

	func setupFooterView() {

		backgroundColor = .systemGray6

		layer.maskedCorners = [
			.layerMinXMaxYCorner,
			.layerMaxXMaxYCorner
		]
		layer.cornerCurve = .continuous
		layer.cornerRadius = 15
	}

	func setupSeparatorView() {

		separatorView = UIView()
		separatorView.backgroundColor = UIColor.label.withAlphaComponent(0.2)

		addSubview(separatorView)

		separatorView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
			separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
			separatorView.topAnchor.constraint(equalTo: topAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 1)
		])

	}

	func setupPreviousMonthButton() {

		previousMonthButton = UIButton()
		previousMonthButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
		previousMonthButton.titleLabel?.textAlignment = .left

		if let chevronImage = UIImage(systemName: "chevron.left.circle.fill") {
			let imageAttachment = NSTextAttachment(image: chevronImage)
			let attributedString = NSMutableAttributedString()
			attributedString.append(NSAttributedString(attachment: imageAttachment))
			attributedString.append(NSAttributedString(string: " Previous"))
			previousMonthButton.setAttributedTitle(attributedString, for: .normal)
		} else {
			previousMonthButton.setTitle("Previous", for: .normal)
		}

		previousMonthButton.titleLabel?.textColor = .label

		addSubview(previousMonthButton)

		previousMonthButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			previousMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
		])

		previousMonthButton.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
	}

	func setupNextMonthButton() {

		nextMonthButton = UIButton()
		nextMonthButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
		nextMonthButton.titleLabel?.textAlignment = .right

		if let chevronImage = UIImage(systemName: "chevron.right.circle.fill") {
			let imageAttachment = NSTextAttachment(image: chevronImage)
			let attributedString = NSMutableAttributedString(string: "Next ")
			attributedString.append(NSAttributedString(attachment: imageAttachment))
			nextMonthButton.setAttributedTitle(attributedString, for: .normal)
		} else {
			nextMonthButton.setTitle("Next", for: .normal)
		}

		nextMonthButton.titleLabel?.textColor = .label

		addSubview(nextMonthButton)

		nextMonthButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
			nextMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
		])

		nextMonthButton.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
	}

	// MARK: - Actions

	@objc func didTapPreviousMonthButton() {
		delegate?.previousMonthButtonTapped()
	}

	@objc func didTapNextMonthButton() {
		delegate?.nextMonthButtonTapped()
	}
}
