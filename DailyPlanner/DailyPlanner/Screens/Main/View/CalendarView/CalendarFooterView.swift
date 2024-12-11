import UIKit

protocol CalendarFooterViewDelegate: AnyObject {
	func previousMonthButtonTapped()
	func nextMonthButtonTapped()
}

final class CalendarFooterView: UIView {

	// MARK: - Public Properties

	weak var delegate: CalendarFooterViewDelegate?
	var separatorView: UIView!
	var previousMonthButton: UIButton!
	var nextMonthButton: UIButton!

	// MARK: - Initialization

	init() {
		super.init(frame: .zero)

		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods


	private func setupViews() {
		setupFooterView()
		setupSeparatorView()
		setupPreviousMonthButton()
		setupNextMonthButton()
	}

	private func setupFooterView() {
		backgroundColor = .systemGray6

		layer.maskedCorners = [
		  .layerMinXMaxYCorner,
		  .layerMaxXMaxYCorner
		]
		layer.cornerCurve = .continuous
		layer.cornerRadius = 15
	}

	private func setupSeparatorView() {
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

	private func setupPreviousMonthButton() {
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

		// Ensure previousMonthButton uses Auto Layout
		previousMonthButton.translatesAutoresizingMaskIntoConstraints = false

		// Add constraints for previousMonthButton
		NSLayoutConstraint.activate([
			previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			previousMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
		])


		// Action
		previousMonthButton.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
	}

	private func setupNextMonthButton() {
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

		// Add constraints for nextMonthButton
		NSLayoutConstraint.activate([
			nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
			nextMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
		])


		nextMonthButton.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
	}

	// MARK: - Actions

	@objc private func didTapPreviousMonthButton() {
		delegate?.previousMonthButtonTapped()
	}

	@objc private func didTapNextMonthButton() {
		delegate?.nextMonthButtonTapped()
	}
}
