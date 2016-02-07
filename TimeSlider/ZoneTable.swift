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
    
    func setupForTimeZone(timeZone:NSTimeZone){
        self.timeZone = timeZone
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .None
        self.reuseIdentifier = "zone\(timeZone.secondsFromGMT)"
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = false
        bounces = true
        self.registerClass(TimeCell.self, forCellReuseIdentifier: reuseIdentifier)
        scrollToHour(getGMTHour()) // todo: Find gmt hour
        self.backgroundColor = UIColor.blackColor()
    }

    func scrollToHour(hour:Int){
        let ip = NSIndexPath(forItem: hour + 12 + (10*24), inSection: 0) // WHY + 12?!
        self.scrollToRowAtIndexPath(ip, atScrollPosition: .Middle, animated: true)
        self.contentOffset.y += 17.0
    }
    
    func getGMTHour() -> Int {
        let gmt = NSTimeZone(abbreviation: "GMT")
        let df = NSDateFormatter()
        df.timeZone = gmt
        df.dateFormat = "H"
        return Int(df.stringFromDate(NSDate()))!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        zoneTableDelegate?.zoneTableDidScrollToPosition(self.contentOffset.y)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return timeZone.name
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 110, bounds.size.width, 30))
        headerView.backgroundColor = UIColor.clearColor()
        
        let f = CGRectMake(0, 0, bounds.size.width, 30)
        let label = UILabel(frame: f)
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "HelveticaNeue", size: 10.0)
        
        let zoneName =  timeZone.name
                                .componentsSeparatedByString("/")[1]
                                .stringByReplacingOccurrencesOfString("_", withString: " ")
        
        label.text = String(zoneName)
        label.center.y = center.y
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier(reuseIdentifier) as! TimeCell
        
        let currentHourGMT = indexPath.row
        let localTimeInZone = (currentHourGMT + (timeZone.secondsFromGMT / 3600)) % 24
        cell.hourLabel.text = "\(localTimeInZone)"
        cell.hourLabel.textColor = UIColor.whiteColor()
        cell.hourLabel.alpha = 0.4
        let brightness:CGFloat = brightnessForHour(localTimeInZone)
        cell.backgroundColor = UIColor(hue:0.59, saturation:0.750, brightness:brightness, alpha:1)
        cell.setWidthAndCenter(bounds.width)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 400 // TODO:Return something crazy fucking high
    }
    
    
    func  brightnessForHour(hour:Int) -> CGFloat {
        let brightest:CGFloat = 12
        return (brightest - abs(CGFloat(hour) - 12)) / 10
    }
    
   
}
