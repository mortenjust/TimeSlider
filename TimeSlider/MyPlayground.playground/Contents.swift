import Cocoa
import UIKit

func  brightnessForHour(hour:Int) -> CGFloat {
    let brightest:CGFloat = 10
    return (brightest - abs(CGFloat(hour) - 15)) / 10
}

func colorForHour(hour:Int) -> UIColor {
    var c = UIColor()
    
}



colorForHour(12)