
//
//  SelectionTableViewController.swift
//  mimi. iOS
//
//  Created by Robert on 08.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

import UIKit

class SelectionTableViewController: UITableViewController {

    @IBOutlet var topViews: [UIView]!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topViews.forEach {
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.layer.shadowRadius = 7
            $0.layer.shadowOpacity = 0.6
            $0.layer.shadowColor = UIColor.lightGray.cgColor

            let imageView = $0.subviews.first(where: { $0 is UIImageView })
            imageView?.layer.cornerRadius = 10
            imageView?.layer.masksToBounds = true
        }
    }

}
