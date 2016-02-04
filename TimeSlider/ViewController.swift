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

        
        // to make them deal with stack view in an appropriate manner:
        // http://stackoverflow.com/questions/30728062/add-views-in-uistackview-programmatically
     
        zones.append(NSTimeZone(forSecondsFromGMT: 1000))
        zones.append(NSTimeZone(forSecondsFromGMT: 1000))
        zones.append(NSTimeZone(forSecondsFromGMT: 1000))
        zones.append(NSTimeZone(forSecondsFromGMT: 1000))
        zones.append(NSTimeZone(forSecondsFromGMT: 1000))


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
        new.setupForIdentifier("zone\(timeZone)")
        stack.addArrangedSubview(new)
        return new
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

