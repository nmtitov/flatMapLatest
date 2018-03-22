//
//  ViewController.swift
//  flatMapLatest
//
//  Created by Nikita Titov on 22/03/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let input = textField.reactive.continuousTextValues.skipNil().logEvents()
        input.observeValues { v in
            print(v)
        }
    }
}

