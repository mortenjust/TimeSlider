//
//  ViewController.swift
//  TimeSlider
//
//  Created by Morten Just Petersen on 1/10/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ZoneTableDelegate {
    
    

    @IBOutlet weak var stack: UIStackView!
    var col:CGFloat = 0

    
    var tables = [ZoneTable]()
    var zones = [NSTimeZone]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        zones.append(NSTimeZone(name: NSTimeZone.systemTimeZone().name)!)
        zones.append(NSTimeZone(name: "America/New_York")!)
        zones.append(NSTimeZone(name: "Europe/London")!)
        zones.append(NSTimeZone(name: "Europe/Copenhagen")!)

        

        for zone in zones {
            let t = addTableForTimeZone(zone)
            t.zoneTableDelegate = self
            tables.append(t)
        }
    }
    
    func zoneTableDidScrollToPosition(offset: CGFloat) {
        scrollAllTablesToPosition(offset)
    }
    
    func scrollAllTablesToPosition(offset:CGFloat){
        for table in tables {
            table.contentOffset.y = offset
        }
    }

    func addTableForTimeZone(timeZone:NSTimeZone) -> ZoneTable {
        let new = ZoneTable()
        new.setupForTimeZone(timeZone)
        stack.addArrangedSubview(new)
        return new
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }

}

