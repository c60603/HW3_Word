//
//  SavePhotoPage.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import SwiftUI

struct SavePhotoPage:View {
    @Binding var currentPage : Pages
    var body: some View{
        ZStack{
            backGround(imgName: .constant("background_01"),opacity: .constant(1))
            
            Text("GameOver")
                .font(.system(size:60, weight: .semibold,design: .monospaced))
                .foregroundColor(.red)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    //Image("pepefog")
                        //.resizable()
                        //.scaledToFit()
                        //.frame(height: 230, alignment: .center)
                        //.clipped()
                }
            }
        }
    }
}

struct SavePhotoPage_Previews: PreviewProvider {
    static var previews: some View {
        SavePhotoPage(currentPage:.constant(Pages.SavePhotoPage))
    }
}

