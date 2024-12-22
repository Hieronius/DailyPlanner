import UIKit

/// Custom cell to store our tasks
final class ToDoCell: UITableViewCell {

	// MARK: - Public Properties

	static let reuseIdentifier = "ToDoCell"

	// MARK: - Static Properties

	private let titleLabel = UILabel()
	private let descriptionLabel = UILabel()
	private let checkboxImageView = UIImageView()

	// MARK: - Initialization

	override init(style: UITableViewCell.CellStyle,
				  reuseIdentifier: String?) {
		super.init(style: style,
				   reuseIdentifier: reuseIdentifier)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(false, animated: false)
	}

	func configure(with task: ToDo) {
		titleLabel.text = task.title
		descriptionLabel.text = task.description
		checkboxImageView.image = task.isCompleted ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
	}

	// MARK: - Private Methods

	private func setupView() {
		backgroundColor = .systemGray6
		// Configure titleLabel
		titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
		contentView.addSubview(titleLabel)

		// Configure descriptionLabel
		descriptionLabel.font = UIFont.systemFont(ofSize: 14)
		descriptionLabel.textColor = .gray
		contentView.addSubview(descriptionLabel)

		// Configure checkboxImageView
		checkboxImageView.contentMode = .scaleAspectFit
		checkboxImageView.tintColor = .systemRed
		contentView.addSubview(checkboxImageView)

		// Set constraints for the views
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		checkboxImageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			checkboxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			checkboxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
			checkboxImageView.heightAnchor.constraint(equalToConstant: 24),

			titleLabel.leadingAnchor.constraint(equalTo: checkboxImageView.trailingAnchor, constant: 8),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

			descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
			descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
		])
	}
}
