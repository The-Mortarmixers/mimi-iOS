//
//  BigButton.swift
//  mimi. iOS
//
//  Created by Robert on 07.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

import UIKit

class BigButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.height / 2
    }

}
