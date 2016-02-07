//
//  TimeCell.swift
//  TimeSlider
//
//  Created by Morten Just Petersen on 1/10/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {
    var hourLabel : UILabel!
    var width : CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForReuse() {

    }
    
    func setWidthAndCenter(width:CGFloat){ // due to some issue with stackview, it seems
        print("set witdth and center \(width)")
                frame.size.width = width
        hourLabel.frame.size.width = width
        hourLabel.center.x = center.x

        print("now set. frame width: \(hourLabel.frame.size.width) cell width: \(bounds.width)")
    }
    
    func setup(){
        
        // todo: Maybe have a addLabel that the adapter can call after it checked that hourlabel was false?
        
        print("dump bounds \(frame)")
        let rect = CGRectMake(0, 0, 100, 30)
        hourLabel = UILabel(frame: rect)
        hourLabel.text = "%HH%"
        hourLabel.adjustsFontSizeToFitWidth = true
        hourLabel.textAlignment = .Center
        hourLabel.center.y = center.y
        hourLabel.font = UIFont(name: "HelveticaNeue", size: 10.0)

        self.addSubview(hourLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
