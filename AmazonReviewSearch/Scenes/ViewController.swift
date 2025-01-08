//
//  ViewController.swift
//  AmazonReviewSearch
//
//  Created by Anastasia Mousa on 5/1/25.
//

import Cocoa

class ViewController: NSViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    
    @IBOutlet weak var headerView: NSTableHeaderView!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = NSTextField(labelWithString: "Search results")
        self.headerView.addSubview(label)
    }

    override var representedObject: Any? {
        didSet {

        }
    }

}

