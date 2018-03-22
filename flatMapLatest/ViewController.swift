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
        let input = textField.reactive.continuousTextValues.skipNil()
        let void = input.map { string in
            return
        }
        let requests = input.flatMap(.latest) { (text: String) -> SignalProducer<String, NoError> in
            return ping(text: text).take(until: void)
        }
        requests.observe { event in
            switch event {
            case let .value(value):
                print("Value: \(value)")
                
            case let .failed(error):
                print("Error: \(error)")
                
            case .completed:
                print("Completed")
                    
            case .interrupted:
                print("Interrupted")
            }
        }
    }
}

func ping(text: String) -> SignalProducer<String, NoError> {
    return SignalProducer<String, NoError> { (observer, lifetime) in
        let task = DispatchWorkItem {
            observer.send(value: "pong \(text)")
            observer.sendCompleted()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: task)
        
        lifetime.observeEnded {
            task.cancel()
            print("observeEnded")
        }
    }
}
