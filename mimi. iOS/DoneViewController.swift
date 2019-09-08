//
//  DoneViewController.swift
//  mimi. iOS
//
//  Created by Robert on 07.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

// Image taken from <div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"             title="Flaticon">www.flaticon.com</a></div>

import UIKit

class DoneViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }

    @IBAction func doneButtonPressed(_ sender: BigButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
