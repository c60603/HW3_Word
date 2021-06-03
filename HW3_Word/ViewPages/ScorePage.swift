//
//  ScorePage.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import SwiftUI
import AVFoundation

extension GamePage{
    var GameOverView:some View{
        ZStack{
            backGround(imgName: .constant("background_01"),opacity: .constant(1))
            
            Text("GameOver")
                .font(.system(size:70, weight: .semibold,design: .monospaced))
                .foregroundColor(.yellow)
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
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                currentPage = Pages.HomePage
                showScorePage = false
            }
        }
    }
    
    var ScorePage:some View{
        ZStack{
            backGround(imgName: .constant("background_00"),opacity: .constant(0.75))
            VStack{
                //Text("Your record time :  600.0")
                Text("Congratulations!")
                    .font(.system(size:55,design: .monospaced))
                    .foregroundColor(.black)
                Text("Your record time : "+String(format:"%.1f", timeClock))
                    .font(.system(size:30,design: .monospaced))
                    .foregroundColor(.blue)
//                TextField("Your Name", text: $username)
//                    .frame(width:300)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                     //.keyboardType(.numberPad)
            }
        }
        .onAppear{
            savePhotos = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5){
                currentPage = Pages.HomePage
                showScorePage = false
            }
        }
    }
}

struct Scorepage_Previews: PreviewProvider {
    static var previews: some View {
        Landscape{
            //GamePage(currentPage: .constant(Pages.GamePage)).ScorePage
            GamePage(currentPage: .constant(Pages.GamePage), savePhotos: .constant(false)).GameOverView
        }
    }
}

