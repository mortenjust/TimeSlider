//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


func get24HourForRow(row:Int) -> Int {
    return row % 24
}


for var i = 0 ; i<100 ; i++ {
    print(get24HourForRow(i))
}