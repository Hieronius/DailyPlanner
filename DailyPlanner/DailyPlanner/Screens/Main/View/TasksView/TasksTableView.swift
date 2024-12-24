import UIKit

/// A custom table view for displaying a list of tasks.
final class TasksTableView: UITableView {

	// MARK: - Initialization

	/// This initializer sets up the table view with a plain style and configures
	init() {
		super.init(frame: .zero, style: .plain)
		configureTableView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private Methods

private extension TasksTableView {

	func configureTableView() {

		backgroundColor = .systemGray6

		layer.cornerRadius = 15
		clipsToBounds = true

		register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)

		register(HourHeaderView.self, forHeaderFooterViewReuseIdentifier: HourHeaderView.reuseIdentifier)
	}
}
