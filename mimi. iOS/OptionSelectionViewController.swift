//
//  OptionSelectionViewController.swift
//  mimi. iOS
//
//  Created by Robert on 07.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

import UIKit

struct Option {
    let name: String
    let color: UIColor
    let selected: Bool
}

class OptionSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var measurements: Measurements? = Measurements(height: Measurement(value: 30, unit: .centimeters),
                                                   width: Measurement(value: 50, unit: .centimeters))

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: BigButton!
    
    private var options: [[Option]] = [
        [
            Option(name: "Test Option", color: .lightGray, selected: false),
            Option(name: "Test 2", color: .blue, selected: false),
            Option(name: "Test 3", color: .blue, selected: false),
            Option(name: "Test 4", color: .orange, selected: false),
            Option(name: "Test 5", color: .red, selected: false),
        ]
    ]

    private var titles = [
        "Locality"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        toggleEnabledForContinueButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let destination = segue.destination as? RequirementsTableViewController {
            destination.measurements = self.measurements
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OptionsTableViewCell
            else { fatalError("Could not dequeue table view cell of correct type") }

        cell.setup(items: self.options[indexPath.section], title: titles[indexPath.section], section: indexPath.section)
        cell.delegate = self

        return cell
    }

    private func toggleEnabledForContinueButton() {
        self.continueButton.isEnabled = self.options.allSatisfy {
            $0.contains(where: { $0.selected })
        }

        self.continueButton.alpha = self.continueButton.isEnabled ? 1.0 : 0.3
    }
}

extension OptionSelectionViewController: OptionsTableViewCellDelegate {
    func didSelect(option: Option, section: Int) {
        self.options[section] = self.options[section].map {
            Option(name: $0.name, color: $0.color, selected: $0.name == option.name)
        }

        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? OptionsTableViewCell
            else { return }

        cell.setup(items: self.options[section], title: titles[section], section: section)
        toggleEnabledForContinueButton()
    }
}
