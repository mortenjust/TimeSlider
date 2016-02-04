//
//  ZoneTable.swift
//  TimeSlider
//
//  Created by Morten Just Petersen on 1/10/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit

protocol ZoneTableDelegate {
    func zoneTableDidScrollToPosition(offset:CGFloat)
}

class ZoneTable: UITableView, UITableViewDataSource, UITableViewDelegate {
    var timeZone : NSTimeZone!
    var reuseIdentifier : String!
    var zoneTableDelegate : ZoneTableDelegate?

    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupForIdentifier(identifier:String){
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .None
        print("zonetable setup")
        self.reuseIdentifier = identifier
        self.delegate = self
        self.dataSource = self        
        self.registerClass(TimeCell.self, forCellReuseIdentifier: reuseIdentifier)
        scrollToHour(currentHour())
    }
    
    func scrollToHour(hour:Int){
        // 20 is the local time
        let ip = NSIndexPath(forItem: currentHour(), inSection: 0)
        self.scrollToRowAtIndexPath(ip, atScrollPosition: .Middle, animated: false)
    }
    
    func currentHour() -> Int {
        // use timeZone to calculate this
        return 20
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        zoneTableDelegate?.zoneTableDidScrollToPosition(self.contentOffset.y)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier(reuseIdentifier) as! TimeCell
        let currentHour = indexPath.row % 24
        cell.hourLabel.text = "\(currentHour)"
        print("returning a cell for hour \(currentHour)")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("zonetable nubmbers of rosws")
        return 400 // TODO:Return something crazy fucking high
    }
    
    
   
}
