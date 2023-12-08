//
//  Calculations.swift
//  sail-v1
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation

func randomDataArray() -> [Double]{
    var dataArray : [Double] = []
    
    for _ in 0...9{
        let randomInt = Int.random(in: 1 ... 3)
        
        if randomInt == 1{
            dataArray.append(150.0)
        }
        else if randomInt == 2{
            dataArray.append(160.0)
        }
        else{
            dataArray.append(170.0)
        }
    }
    
    return dataArray
}



