//
//  OpenHABSelectionTableViewController.swift
//  GLAD
//
//  Created by Matias Gualino on 9/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import UIKit

class OpenHABSelectionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak private var tableView : UITableView!
    var mappings : [OpenHABWidgetMapping]!
    var selectionItemCallback : ((selectedMappingIndex: Int) -> Void)?
    var selectionItem : OpenHABItem!
    
	init() {
        super.init(nibName: "OpenHABSelectionTableViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mappings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var CellIdentifier : NSString = "SelectionCell"
        var cell : UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier as String, forIndexPath: indexPath) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier as String)
        }
        var mapping : OpenHABWidgetMapping = mappings[indexPath.row]
        cell!.textLabel!.text = mapping.label
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Selected mapping \(indexPath.row)")
        if self.selectionItemCallback != nil {
            self.selectionItemCallback!(selectedMappingIndex: indexPath.row)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

}
