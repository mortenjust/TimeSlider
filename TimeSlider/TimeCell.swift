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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("cell awake from nib")
        // Initialization code
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        print("cell:init 1")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        print("cell init 2")
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForReuse() {
        print("cell:preparing for reuse")
    }
    
    func setup(){
        print("cell:setup()")
        let rect = CGRectMake(0, 0, 20, 20)
        hourLabel = UILabel(frame: rect)
        hourLabel.text = "%HH%"
        self.addSubview(hourLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
