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
		self.tableView.delegate = self
		self.tableView.dataSource = self
		var backgroundImageView = UIImageView(frame: self.tableView.frame)
		backgroundImageView.image = UIImage(named:"background")
		backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
		self.tableView.backgroundView = backgroundImageView
		self.tableView.tableFooterView = UIView()
		
		var genericWidgetCellNib = UINib(nibName: "GenericUITableViewCell", bundle: nil)
		self.tableView.registerNib(genericWidgetCellNib, forCellReuseIdentifier: "genericWidgetCell")
		
		self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mappings.count
    }
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        var cell : GenericUITableViewCell = tableView.dequeueReusableCellWithIdentifier("genericWidgetCell") as! GenericUITableViewCell
		
		self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
		var separatorView : UIView = UIView(frame: CGRectMake(50, cell.frame.height - 1, cell.frame.size.width, 1))
		
		separatorView.backgroundColor = UIColor.whiteColor()
		cell.contentView.addSubview(separatorView)
		
		var mapping : OpenHABWidgetMapping = mappings[indexPath.row]
		cell.loadWidgetMapping(mapping)
		cell.displayWidgetMapping()
		return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Selected mapping \(indexPath.row)")
        if self.selectionItemCallback != nil {
            self.selectionItemCallback!(selectedMappingIndex: indexPath.row)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

}
