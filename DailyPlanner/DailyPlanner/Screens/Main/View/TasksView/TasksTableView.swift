import UIKit

final class TasksTableView: UITableView {

	// MARK: - Initialization

	init() {
		super.init(frame: .zero, style: .plain)
		configureTableView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureTableView() {
		backgroundColor = .systemGray6

		layer.cornerRadius = 15
		clipsToBounds = true

		register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)

		register(HourHeaderView.self, forHeaderFooterViewReuseIdentifier: HourHeaderView.reuseIdentifier)
	}
}
