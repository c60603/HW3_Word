//
//  Vocabulary.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import Foundation

struct Vocabulary{
    var French : String
    var English : String
    var fileName : String
    init(French:String,English:String,fileName:String){
        self.French = French
        self.English = English
        self.fileName = fileName
    }
    init(){
        self.French = ""
        self.English = ""
        self.fileName = ""
    }
}

var vocabularyDataSet:[Vocabulary]=[
    Vocabulary(French: "voiture", English: "car", fileName: "car"),
    Vocabulary(French: "avion", English: "airplane", fileName: "plane"),
    Vocabulary(French: "Couteau", English: "knife", fileName: "knife"),
    Vocabulary(French: "former", English: "train", fileName: "train"),
    Vocabulary(French: "rouleau", English: "gun", fileName: "gun"),
    Vocabulary(French: "pitre", English: "clown", fileName: "clown"),
    Vocabulary(French: "hippopotame", English: "hippo", fileName: "hippo"),
    Vocabulary(French: "serpent", English: "snake", fileName: "snake"),
    Vocabulary(French: "Souris", English: "mouse", fileName: "mouse"),
    Vocabulary(French: "Soleil", English: "sun", fileName: "sun"),
    Vocabulary(French: "lune", English: "moon", fileName: "moon")
]
