//
//  SettingsTableView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-12.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct SettingsTableViewViewModel: Codable {
    let currentFontName: String
    let currentFontDescription: String

    init(currentFontName: String, currentFontDescription: String) {
        self.currentFontName = currentFontName
        self.currentFontDescription = currentFontDescription
    }
}

class SettingsTableView: UITableViewController {

    var viewModel: SettingsTableViewViewModel

    struct TableViewSection {

        enum CellType {
            case theme
        }

        let rows: [CellType]

        init(rows: [CellType]) {
            self.rows = rows
        }
    }

    fileprivate var sections = [TableViewSection]()

    init(viewModel: SettingsTableViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setUpTheming()
        super.viewDidLoad()
        self.setupTableView()
        self.configureCellTypes()
        self.registerTableViewCells()
        self.title = "Settings"
    }

    // MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .theme:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "Theme")
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .theme:
            let view = ThemeSelectionTableView()
            navigationController?.pushViewController(view, animated: true)
        }
    }
}

extension SettingsTableView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension SettingsTableView {

    func setupTableView() {
        registerTableViewCells()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = themeProvider.currentTheme.backgroundColor
    }

    func registerTableViewCells() {
        tableView.register(TableViewButtonCell.self, forCellReuseIdentifier: "TableViewButtonCell")
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()
        sections.append(.init(rows: [.theme]))

        self.sections = sections
    }
}

extension SettingsTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.tableView.backgroundColor = theme.backgroundColor
    }
}

