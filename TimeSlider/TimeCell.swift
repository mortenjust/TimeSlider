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
        frame.size.width = width
        hourLabel.frame.size.width = width
        hourLabel.center.x = center.x


    }
    
    func setup(){
        // todo: Maybe have a addLabel that the adapter can call after it checked that hourlabel was false?
        let rect = CGRectMake(0, 0, 100, 30)
        hourLabel = UILabel(frame: rect)
        hourLabel.text = "%HH%"
        hourLabel.textColor = UIColor.whiteColor()
        hourLabel.alpha = 0.6
        hourLabel.adjustsFontSizeToFitWidth = true
        hourLabel.textAlignment = .Center


        hourLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        self.addSubview(hourLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
