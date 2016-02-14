//
//  ViewController.swift
//  TimeSlider
//
//  Created by Morten Just Petersen on 1/10/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ZoneTableDelegate, TimeZonePickerDelegate {
    
    @IBOutlet weak var stack: UIStackView!
    var col:CGFloat = 0
    
    @IBOutlet weak var addButton: UIButton!

    
    var tables = [ZoneTable]()
    var zones = [NSTimeZone]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let rawZones:NSData = NSUserDefaults.standardUserDefaults().objectForKey(C.SavedZones) as? NSData {
            zones = (NSKeyedUnarchiver.unarchiveObjectWithData(rawZones) as? [NSTimeZone])!
            
        } else {
            // add defaults
            zones.append(NSTimeZone(name: "America/New_York")!)
            zones.append(NSTimeZone(name: "Europe/London")!)
            

//            zones.append(NSTimeZone(name: "Europe/Copenhagen")!)
            
            let saveable = NSKeyedArchiver.archivedDataWithRootObject(zones)
            NSUserDefaults.standardUserDefaults().setObject(saveable, forKey: C.SavedZones)
            print("no defaults, now saved")
        }
        
        

        zones.append(NSTimeZone(name: NSTimeZone.systemTimeZone().name)!)
        addAllZones()
        hideNavigationBar()
     }
    

    func didTap(){
        print("Did tap")
    }
    
    func hideNavigationBar(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        hideNavigationBar()
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(true)
    }
    
    
    func zoneTableDidScrollToPosition(offset: CGFloat) {
        scrollAllTablesToPosition(offset)
    }
    
    func scrollAllTablesToPosition(offset:CGFloat){
        for table in tables {
            table.contentOffset.y = offset
        }
    }
    
    func zoneTableTapped(zoneTable: ZoneTable) {
        removeZoneTable(zoneTable)
    }
    
    
    func removeZoneTable(zoneTable:ZoneTable){
        if zoneTable.isHomeZone { return }
        
        // remove from allzones
        for(var i = 0; i < zones.count ; i++){
            if zones[i] == zoneTable.timeZone {
                zones.removeAtIndex(i)
            }
        }
        
        // remove from tables
        for(var i = 0; i < tables.count ; i++){
            if tables[i] == zoneTable {
                tables.removeAtIndex(i)
            }
        }
        
        // remove from stack view - animate?

        
        self.stack.removeArrangedSubview(zoneTable)
        addAllZones()
    }
    
    
    func emptyStack(stack:UIStackView){
        for s in stack.subviews {
            s.removeFromSuperview()
        }
    }
    
    func addAllZones(){
        tables.removeAll()
        emptyStack(stack)
        
        zones.sortInPlace({ $0.secondsFromGMT < $1.secondsFromGMT })
        
        for zone in zones {
            addZone(zone)
        }
    }
    
    func timeZonePickerDidSelectZoneWithName(name: String) {
        hideNavigationBar()
        let z = NSTimeZone(name: name)!
        zones.append(z)
        
        
        /// save in ns userdefaults
        addAllZones()

    }
    
    func addZone(zone:NSTimeZone){
        let t = addTableForTimeZone(zone)
        t.zoneTableDelegate = self
        tables.append(t)
    }

    func addTableForTimeZone(timeZone:NSTimeZone) -> ZoneTable {
        let new = ZoneTable()
        new.setupForTimeZone(timeZone)
        stack.addArrangedSubview(new)
        return new
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    

    
    func fadeInAddButton(){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.addButton.alpha = 1
        }
    }


    func fadeOutAddButton(){
        fadeOutAddButton(0)
    }
    
    func fadeOutAddButton(delay:NSTimeInterval){
        UIView.animateWithDuration(0.3, delay: delay, options: [], animations: { () -> Void in
            self.addButton.alpha = 0
            }, completion: nil)
    }
    
    func zoneTableDidStopScrolling() {
        fadeOutAddButton()
    }
    func zoneTableDidStartScrolling() {
        fadeInAddButton()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue")
        let goNext = segue.destinationViewController as! TimeZoneViewControllerTableViewController
        goNext.delegate = self
    }
    
}

