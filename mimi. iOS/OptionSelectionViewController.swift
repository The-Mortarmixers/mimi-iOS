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
            Option(name: "Inside",
                   color: UIColor(red: 77/255.0, green: 80/255.0, blue: 87/255.0, alpha: 1.0),
                   selected: true),
            Option(name: "Outside",
                   color: UIColor(red: 166/255.0, green: 176/255.0, blue: 126/255.0, alpha: 1.0),
                   selected: false),
            Option(name: "Don't Know",
                   color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0),
                   selected: false)
        ],
        [
            Option(name: "Yes",
                   color: UIColor(red: 104/255.0, green: 164/255.0, blue: 87/255.0, alpha: 1.0),
                   selected: false),
            Option(name: "No",
                   color: UIColor(red: 201/255.0, green: 64/255.0, blue: 46/255.0, alpha: 1.0),
                   selected: true),
            Option(name: "Don't Know",
                   color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0),
                   selected: false)
        ],
        [
            Option(name: "Wood",
                   color: UIColor(red: 163/255.0, green: 83/255.0, blue: 13/255.0, alpha: 1.0),
                   selected: false),
            Option(name: "Brick",
                   color: UIColor(red: 204/255.0, green: 119/255.0, blue: 136/255.0, alpha: 1.0),
                   selected: false),
            Option(name: "Stone",
                   color: UIColor(red: 135/255.0, green: 130/255.0, blue: 131/255.0, alpha: 1.0),
                   selected: true),
            Option(name: "Wallpaper",
                   color: UIColor(red: 116/255.0, green: 164/255.0, blue: 168/255.0, alpha: 1.0),
                   selected: false)
        ]
    ]

    private var titles = [
        "Locality",
        "Will it be exposed to a lot of water?",
        "Surface Type"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        toggleEnabledForContinueButton()
        self.tableView.contentInset.bottom = 250
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
