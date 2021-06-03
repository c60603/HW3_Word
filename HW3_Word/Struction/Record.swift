//
//  Record.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import Foundation

struct Record : Identifiable,Codable{
    var id = UUID()
    var date : Date
    var name : String
    var useTime : Double
}
