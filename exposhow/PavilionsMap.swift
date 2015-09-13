//
//  PavilionsMap.swift
//  exposhow
//
//  Created by Ulitka on 12.09.15.
//  Copyright (c) 2015 Ampullarius. All rights reserved.
//

import Foundation
import UIKit

struct Pavilion {
    let name: String
    let pavilion: String
    let position: CGRect
}

class PavilionsMap {
    
    var pavilions:[Pavilion]
    
    init() {
        let pavilionsFile = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("pavilions.csv")

        pavilions = []
        if let csv_file = String(contentsOfFile: pavilionsFile, encoding: NSUTF8StringEncoding) {
            csv_file.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet()).enumerateLines { line, stop in
                let values = line.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ";"))
                if values.count != 6 {
                    return
                }
                let name = values[0]
                let pavilion = values[1]
                let x = values[2].toInt()
                let y = values[3].toInt()
                let width = values[4].toInt()
                let height = values[5].toInt()
                if let x = x, let y = y, let width = width, let height = height {
                    self.pavilions.append(Pavilion(name: name, pavilion: pavilion, position: CGRect(x: x, y: y, width: width, height: height)))
                }
            }
        } else {
            println("Error opening file")
        }
        pavilions.sort { $0.name.lowercaseString < $1.name.lowercaseString }
    }
    
    var count:Int {
        return pavilions.count
    }
    
    subscript(index:Int) -> Pavilion {
        return pavilions[index]
    }

    func indexOfPavilionAtPoint(point:CGPoint) -> Int? {
        for i in 0..<pavilions.count {
            if pavilions[i].position.contains(point) {
                return i
            }
        }
        return nil
    }
}