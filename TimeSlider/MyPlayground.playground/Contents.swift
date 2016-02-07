import Cocoa

func  brightnessForHour(hour:Int) -> CGFloat {
    let brightest:CGFloat = 10
    return (brightest - abs(CGFloat(hour) - 15)) / 10
}


for i in 0...23 {
    brightnessForHour(i)
}


let here = NSTimeZone.systemTimeZone()

//-(NSString *)getUTCFormateDate:(NSDate *)localDate
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:localDate];
//    [dateFormatter release];
//    return dateString;
//}

func getGMTHour() -> Int {
    let gmt = NSTimeZone(abbreviation: "GMT")
    let df = NSDateFormatter()
    df.timeZone = gmt
    df.dateFormat = "H"
    return Int(df.stringFromDate(NSDate()))!
}

getGMTHour()

NSTimeZone.abbreviationDictionary().count
NSTimeZone.knownTimeZoneNames()

for z in NSTimeZone.knownTimeZoneNames() {
    print(z)
}



