//
//  OptionView.swift
//  mimi. iOS
//
//  Created by Robert on 07.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

import UIKit

class OptionView: UIView {

    @IBOutlet private var label: UILabel!

    var option: Option?

    func setup(for item: Option) {
        self.option = item
        label.text = item.name
        self.label.textColor = .white
        self.backgroundColor = item.color
        self.alpha = item.selected ? 1.0 : 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = item.selected ? 1 : 0.2
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
}
