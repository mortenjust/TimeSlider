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
    func zoneTableDidStartScrolling()
    func zoneTableDidStopScrolling()
    func zoneTableTapped(zoneTable:ZoneTable)
}

class ZoneTable: UITableView, UITableViewDataSource, UITableViewDelegate {
    var timeZone : NSTimeZone!
    var reuseIdentifier : String!
    var zoneTableDelegate : ZoneTableDelegate?
    var isHomeZone = false
    
    static let warmSunScheme = (
        night: UIColor(hue:0.055, saturation:0.943, brightness:0.757, alpha:1),
        morning: UIColor(hue:0.096, saturation:0.713, brightness:0.957, alpha:1),
        lunch: UIColor(hue:0.148, saturation:0.319, brightness:0.984, alpha:1),
        afternoon: UIColor(hue:0.096, saturation:0.713, brightness:0.957, alpha:1),
        evening: UIColor(hue:0.066, saturation:0.738, brightness:0.957, alpha:1)
    )
    
    let darkBrownScheme = (
        night: UIColor(hue:0, saturation:0, brightness:0, alpha:1),
        morning: UIColor(hue:0.046, saturation:0.404, brightness:0.349, alpha:1),
        lunch: UIColor(hue:0.045, saturation:0.421, brightness:0.447, alpha:1),
        afternoon: UIColor(hue:0.030, saturation:0.562, brightness:0.349, alpha:1),
        evening: UIColor(hue:1, saturation:0.619, brightness:0.247, alpha:1)
    )
    
    var segCols:(night:UIColor, morning:UIColor, lunch:UIColor, afternoon:UIColor, evening:UIColor)!
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupForTimeZone(timeZone:NSTimeZone){
        segCols = darkBrownScheme
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
        
        if timeZone == NSTimeZone.systemTimeZone() {
            isHomeZone = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: "didTap")
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPress")
        
        addGestureRecognizer(tap)
        addGestureRecognizer(longPress)
    }
    
    func didTap(){
        zoneTableDelegate?.zoneTableTapped(self)
    }
    
    func didLongPress(){
        zoneTableDelegate?.zoneTableTapped(self)
    }
    

    func scrollToHour(hour:Int){
        let ip = NSIndexPath(forItem: hour + 12 + (50*24), inSection: 0) // WHY + 12?!
        self.scrollToRowAtIndexPath(ip, atScrollPosition: .Middle, animated: true)
        self.contentOffset.y += 15.0
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
//        let brightness:CGFloat = brightnessForHour(localTimeInZone)
//        cell.backgroundColor = UIColor(hue:0.10,  saturation:0.750, brightness:brightness, alpha:1)
        cell.backgroundColor = colorForHour(localTimeInZone)
        
        cell.setWidthAndCenter(bounds.width)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 40000 // TODO:Return something crazy fucking high
    }
    
    func usesAMPM() -> Bool {
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: locale)!
        if dateFormat.rangeOfString("a") != nil {
            return true
        }
        else {
            return false
        }
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        zoneTableDelegate?.zoneTableDidStartScrolling()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        zoneTableDelegate?.zoneTableDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            zoneTableDelegate?.zoneTableDidStopScrolling()
            }
    }
    
    func colorForHour(hour:Int) -> UIColor {
        var c:UIColor
        
        switch(hour){
        case (0...5), (23...24):
            c = segCols.night
            break
        case (5...10):
            c = segCols.morning
            break
        case( 10...14):
            c = segCols.lunch
            break
        case (14...18):
            c = segCols.afternoon
            break
        case (18...23):
            c = segCols.evening
            break
        default:
            c = UIColor.blackColor()
        }
        
        return c
    }
    
    
    func  brightnessForHour(hour:Int) -> CGFloat {
        let brightest:CGFloat = 12
        return (brightest - abs(CGFloat(hour) - 12)) / 10
    }
    
   
}
