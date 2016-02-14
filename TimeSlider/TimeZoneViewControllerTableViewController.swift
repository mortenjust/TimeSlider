//
//  TimeZoneViewControllerTableViewController.swift
//  TimeSlider
//
//  Created by Morten Just Petersen on 2/12/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit

protocol TimeZonePickerDelegate {
    func timeZonePickerDidSelectZoneWithName(name:String)
}

class TimeZoneViewControllerTableViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    var allZones : [String]!
    var filteredZones : [String]!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var delegate : TimeZonePickerDelegate!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allZones = NSTimeZone.knownTimeZoneNames()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true

        tableView.tableHeaderView = searchController.searchBar

        
    }
    
    override func viewDidAppear(animated: Bool) {
        searchController.delegate = self
        searchController.active = true
        searchController.searchBar.hidden = false
        searchController.searchBar.becomeFirstResponder()
        searchController.becomeFirstResponder()
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        print("didPresentSearchController")
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        print("didDismissSearchController")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func filterContentForTextSearch(searchText:String, scope:String = "All") {
        filteredZones = allZones.filter { zone in
            return zone.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForTextSearch(searchController.searchBar.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredZones.count
        }
        return allZones.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeZoneCell", forIndexPath: indexPath)

        var zone = String()
        
        if searchController.active && searchController.searchBar.text != "" {
            zone = filteredZones[indexPath.row]
        } else {
            zone = allZones[indexPath.row]
            }

        cell.textLabel?.text = zone
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var zoneName:String!
        
        print("didSelectRowAtIndexPath")
        if searchController.active && searchController.searchBar.text != "" {
            zoneName = filteredZones[indexPath.row]
            print("got a search ")
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            zoneName = allZones[indexPath.row]
            print("did not search")
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        delegate?.timeZonePickerDidSelectZoneWithName(zoneName)
    //    navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation


}
