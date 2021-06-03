//
//  PageSwitch.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import SwiftUI
//import AVFoundation

enum Pages{
    case HomePage, GamePage, SavePhotoPage//, GameOverPage, ScorePage
}
struct PageSwitch:View {
    @State var currentPage = Pages.HomePage
    @State var savePhotos:Bool = false
//    @State var looper: AVPlayerLooper?
//    @State var soundEffecter = AVPlayer()
    var body: some View{
        ZStack{
            switch currentPage{
            case Pages.HomePage:
                HomePage(currentPage: $currentPage,savePhotos: $savePhotos)
            case Pages.GamePage:
                GamePage(currentPage: $currentPage,savePhotos: $savePhotos)
            case Pages.SavePhotoPage:
                SavePhotoPage(currentPage: $currentPage)
            }
        }
    }
}

struct PageSwitch_Previews: PreviewProvider {
    static var previews: some View {
        PageSwitch()
    }
}
