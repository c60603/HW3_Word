//
//  HomePage.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import SwiftUI

struct HomePage: View {
    @Binding var currentPage:Pages
    @Binding var savePhotos:Bool
    @State private var processedImage:UIImage?
    var body: some View {
        let screenWidth:CGFloat = UIScreen.main.bounds.size.width
        //let screenHeight:CGFloat = UIScreen.main.bounds.size.height
        ZStack{
            backGround(imgName: .constant("background_00"),opacity: .constant(1))
            VStack{
                Text("Bienvenue!")
                    .font(.system(size: 45,weight:.bold,design:.monospaced))
                    .foregroundColor(Color(red: 255/255, green: 255/255, blue: 0/255))
                    .multilineTextAlignment(.center)
                    .frame(width:screenWidth, height: 60)
                    .padding(.top,110)
                Spacer()
            }
            VStack{
                Button(action: {currentPage = Pages.GamePage}, label: {
                    Text("Play")
                        .font(.system(size: 30,weight:.bold,design:.monospaced))
                        .foregroundColor(Color(red: 255/255, green: 255/255, blue: 0/255))
                        .multilineTextAlignment(.center)
                        .frame(width:screenWidth * 0.75, height: 60)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 255/255, green: 255/255, blue: 0/255), style: StrokeStyle(lineWidth: 5)))
                })
                .padding(.top,100)
                
                if(savePhotos){
                    Button(action: {
                        //currentPage = Pages.SavePhotoPage
                        savePhoto()
                    }, label: {
                        Text("Photos")
                            .font(.system(size: 20,weight:.bold,design:.monospaced))
                            .foregroundColor(Color(red: 255/255, green: 255/255, blue: 0/255))
                            .multilineTextAlignment(.center)
                            .frame(width:screenWidth * 0.5, height: 45)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 255/255, green: 255/255, blue: 0/255), style: StrokeStyle(lineWidth: 2)))
                    })
                    .padding(.top)
                }
            }
        }
    }
    func savePhoto(){
        let photoName = "background_0"
        for i in 0...4{
            processedImage = UIImage(named: photoName+String(i))
            
            guard let processedImage = self.processedImage else{ return }
            
            let imageSaver = ImageSaver()
            
            imageSaver.successHandler = {
                print("Success!")
            }

            imageSaver.errorHandler = {
                print("Oops: \($0.localizedDescription)")
            }

            imageSaver.writeToPhotoAlbum(image: processedImage)
        }
       
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        
//        let screenWidth:CGFloat = UIScreen.main.bounds.size.width
//        let screenHeight:CGFloat = UIScreen.main.bounds.size.height
//        LightAndDark {
        Landscape {
                Group {
                    HomePage(currentPage: .constant(Pages.HomePage),savePhotos:.constant(true))
                }
            }
//        }
    }
}

struct backGround: View {
    @Binding var imgName:String
    @Binding var opacity:Double
    var body: some View {
        Image(imgName=="" ? "background_00" : imgName)
            .resizable()
            .opacity(opacity<=0 ? 1 : opacity)
            .scaledToFill()
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
