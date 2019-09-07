//
//  OptionsTableViewCell.swift
//  mimi. iOS
//
//  Created by Robert on 07.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

import UIKit

protocol OptionsTableViewCellDelegate: class {
    func didSelect(option: Option, section: Int)
}

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet var optionViews: [OptionView]!
    @IBOutlet weak var title: UILabel!

    weak var delegate: OptionsTableViewCellDelegate?

    private var section: Int?

    func setup(items: [Option], title: String, section: Int) {
        self.title.text = title
        self.section = section
        
        for (option, view) in zip(items, optionViews) {
            view.setup(for: option)
            view.isHidden = false
        }

        guard items.count < optionViews.count
            else { return }
        
        for i in items.count..<optionViews.count {
            optionViews[i].isHidden = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        for view in optionViews {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectView))
            view.addGestureRecognizer(recognizer)
        }
    }

    @objc private func didSelectView(recognizer: UIGestureRecognizer) {
        guard let view = recognizer.view as? OptionView, let option = view.option, let section = self.section
            else { return }

        delegate?.didSelect(option: option, section: section)
    }
}
