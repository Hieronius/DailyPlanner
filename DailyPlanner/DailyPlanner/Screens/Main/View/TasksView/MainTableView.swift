import UIKit

final class MainTableView: UITableView {

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
		register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)
	}
}
