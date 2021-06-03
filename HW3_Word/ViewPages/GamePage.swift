//
//  GamePage.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import SwiftUI
import AVFoundation

class alphabet:ObservableObject{
    @Published var pos = [CGRect]()
    @Published var correct = [Bool]()
}

struct GamePage:View {
    @Binding var currentPage:Pages
    @Binding var savePhotos:Bool
    let color: [Color] = [.gray,.red,.orange,.yellow,.green,.purple,.pink]
    let timeMax:CGFloat = 300
    let maxPlayRounds:Int = 10
    let synthesizer = AVSpeechSynthesizer()
    //@State var playerItem = AVPlayerItem(url : Bundle.main.url(forResource: "crrect_answer", withExtension: "mp3")!)
    //var correctPlayer: AVPlayer{ AVPlayer.sharedCorrectPlayer }
    //var errorPlayer:   AVPlayer{ AVPlayer.sharedErrorPlayer }
    @State         var showScorePage:Bool = false
    @State private var showAns:Bool = false
    //@State private var scorePageSelect:Int = 0
    @State         var username = String()
    @State private var vocabularyOrder = [Int]()
    @State private var fgColor: Color = .gray
    @State private var offset = [CGSize]()
    @State private var newPosition = [CGSize]()
    @State var ans = alphabet()//[CGRect]()
    @State var ques = alphabet()//[CGRect]()
    @State private var ansTextSize:CGFloat = 50
    @State private var quesTextSize:CGFloat = 60
    @State private var vocaSpeak = [Bool]()
    @State private var ansChars = [String]()
    @State private var quesChars = [String]()
    @State private var currentVoca = Vocabulary()
    @State private var roundChanging:Bool = false
    @State private var roundCount = Int()
    @State private var timer: Timer?
    @State         var timeClock = CGFloat()
//    var dragGesture: some Gesture {
//            DragGesture(coordinateSpace: .global)
//                .onChanged({ value in
//                   print(value.location)
//                   offset.width = newPosition.width + value.translation.width
//                   offset.height = newPosition.height + value.translation.height
//              })
//                .onEnded({ value in
//                    newPosition = offset
//                })
//        }
    func initialGame(){
        vocabularyOrder.removeAll()
        //playRoundCount = 0
        for i in 0...vocabularyDataSet.count-1{
            vocabularyOrder.append(i)
        }
        vocabularyOrder.shuffle()
        timeClock = timeMax
        roundCount = 0
        gamePlay()
        print("initialGame end")
    }
    
    func initialRound(){
        username = ""
        showAns = false
        currentVoca = vocabularyDataSet[vocabularyOrder.removeLast()]
        vocabularyInit(voca:currentVoca.French)
        strSpeacker(str:"")
    }
    
    func gamePlay(){
        if(vocabularyOrder.count<=0){
            showScorePage = true
            return
        }
        nextRoundDelay()
        initialRound()
    }
    
    var body: some View{
        ZStack{
            backGround(imgName: .constant("background_04"),opacity: .constant(0.6))
            HStack{
                VStack{
                    Button(action: {
                        showAns = !showAns
                        
                    }, label: {
                        Image("light")
                            .resizable()
                            //.background(Color.white)
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(100)
                            .clipped()
                    })
                    Spacer()
                }

                Spacer()
                VStack(alignment:.trailing,spacing:10){
                    if(timeClock>0){
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 50, height: 100*(timeClock/timeMax))
                            .cornerRadius(10)
                            .clipped()
                            .padding(.top,100*(1 - timeClock/timeMax))
                            .overlay(rectOutsider)
                    }
                    else{
                        rectOutsider
                    }
                }
                .padding(.bottom,0)
            }
            if(roundChanging){
                Text("Round \(roundCount+0)")
                    .font(.system(size:100,design: .monospaced)).foregroundColor(Color(red: 255/255, green: 255/255, blue: 0/255))
                    //.frame(height:200)
            }
            else{
                vocabularyImage
                VStack{
//                    Button(action: {currentPage = Pages.HomePage}, label: {
//                        Text("Button")
//                    })
                    Spacer()
                    HStack(alignment: .center,spacing:15){
                        Group{
                            ForEach(quesChars.indices,id:\.self){
                                (index) in
                                Text(showAns ? "\(quesChars[index])" : "")//alphabet background
                                    .font(.system(size:35,design: .monospaced))
                                    .foregroundColor(.blue)
                                    .frame(width: quesTextSize, height: quesTextSize)
                                    .background(Color.black)
                                    .cornerRadius(100)
                                    .overlay(RoundedRectangle(cornerRadius: 100)
                                                .stroke(Color.purple,lineWidth: 5))
                                    .overlay(GeometryReader(content:{geometry in
                                        let _ = updatePos(geometry:geometry,ptr:&ques.pos[index])
                                        Color.clear
                                    }))
                                    .onTapGesture {
                                        print("quesPos[\(index)]:\(ques.pos[index])")
                                    }
                            }
                        }
                    }
                    .padding(.bottom)
                }
                VStack{
                    HStack(alignment: .center,spacing:15){
                        Group{
                            ForEach(ansChars.indices,id:\.self){
                                (index) in
                                Text("\(ansChars[index])")
                                    .font(.system(size:35,design: .monospaced))
                                    .foregroundColor(.yellow)
                                    .frame(width: ansTextSize, height: ansTextSize)
                                    .background(fgColor)
                                    .cornerRadius(100)
                                    .overlay(RoundedRectangle(cornerRadius: 100)
                                                .stroke(Color.yellow,lineWidth: 5))
                                    .overlay(GeometryReader(content:{geometry in
                                        let _ = updatePos(geometry:geometry,ptr:&ans.pos[index])
                                        Color.clear
                                    }))
                                    .onTapGesture {
                                        print("offset[\(index)]:\(offset[index])")
                                        print("newPosition[\(index)]:\(newPosition[index])")
                                        print("ansPos[\(index)]:\(ans.pos[index])")
                                        print("(\(ans.pos[index].origin.x-newPosition[index].width),\(ans.pos[index].origin.y-newPosition[index].height))")
                                        fgColor = color.randomElement()!
                                    }
                                    .offset(offset[index])
                                    .gesture(DragGesture()
                                                .onChanged({value in
                                                    if(ans.correct[index]){ return }
                                                    if(!vocaSpeak[index]){
                                                        vocaSpeak[index] = true
                                                        strSpeacker(str:ansChars[index])
                                                    }
                                                    offset[index].width = value.translation.width + newPosition[index].width
                                                    offset[index].height = value.translation.height + newPosition[index].height
                                                })
                                                .onEnded({ value in
                                                    if(ans.correct[index]){ return }
                                                    vocaSpeak[index] = false
                                                    newPosition[index].width = offset[index].width
                                                    newPosition[index].height = offset[index].height
                                                    for i in 0...quesChars.count-1{
                                                        if(ansChars[index] == quesChars[i] && !ques.correct[i]){
                                                            if(cmpDistance(dic:(ansTextSize+quesTextSize)/2,A:ques.pos[i],Asize: quesTextSize,B:ans.pos[index],Bsize: ansTextSize)){
                                                                print("cmpDistance pass")
                                                                print("ques.pos[\(i)]:\(ques.pos[i].origin)")
                                                                print("ans.pos[\(index)]:\(ans.pos[index].origin)")
                                                                print("offset[\(index)]:\(offset[index])")
                                                                print("newPosition[\(index)]:\(newPosition[index])")
                                                                offset[index].width = ques.pos[i].origin.x - (ans.pos[index].origin.x-newPosition[index].width) + 5
                                                                offset[index].height = ques.pos[i].origin.y - (ans.pos[index].origin.y-newPosition[index].height) + 5
                                                                newPosition[index] = offset[index]
                                                                
                                                                ans.correct[index] = true
                                                                ques.correct[i] = true
                                                                //correctPlayer.playFromStart()
                                                                break
                                                            }
                                                        }
                                                    }
                                                    if(!ans.correct[index]){
                                                        offset[index] = .zero
                                                        newPosition[index] = .zero
                                                        //errorPlayer.playFromStart()
                                                    }
                                                    var pass = true
                                                    for i in ans.correct{
                                                        pass = pass && i
                                                        if(!pass){ break }
                                                    }
                                                    if(pass){
                                                        self.timer?.invalidate()
                                                        strSpeacker(str:currentVoca.French)
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                                            gamePlay()
                                                        }
                                                    }
                                                })
                                    )
                            }
                        }
                    }
                    .padding(.top,25)
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented:$showScorePage,content:{
            if(scorePageSelect()){
                ScorePage
            }
            else{
                GameOverView
            }
        })
        .onAppear{
            initialGame()
        }
        .onDisappear{
            self.timer?.invalidate()
        }
//        .onAppear(perform:{initialGame()})
    }
}

extension GamePage{
    func cmpDistance(dic:CGFloat,A:CGRect,Asize:CGFloat,B:CGRect,Bsize:CGFloat)->Bool{
        let Dis = pow(dic,2)
        let aX:CGFloat = A.origin.x + Asize/2
        let aY:CGFloat = A.origin.y + Asize/2
        let bX:CGFloat = B.origin.x + Bsize/2
        let bY:CGFloat = B.origin.y + Bsize/2
        let tmp = pow(aX-bX,2)+pow(aY-bY,2)
        print("|A-B| = \(sqrt(tmp))")
        if(Dis > tmp){
            return true
        }
        return false
    }
    func strSpeacker(str:String,rate:Float=0.05){
        let tmp = AVSpeechUtterance(string: str)
        tmp.voice = AVSpeechSynthesisVoice(language: "de-DE")
        tmp.rate = rate
        synthesizer.speak(tmp)
    }
//    func soundEffectPlayer(/*str:String="crrect_answer"*/){
//        //
//    }
    func scorePageSelect()->Bool{
        self.timer?.invalidate()
        if(vocabularyOrder.count <= 0 && timeClock>0){
            return true//scarepage
        }
        else{
            return false//gameoverview
        }
    }
    func vocabularyInit(voca:String){
        vocaSpeak.removeAll()
        ansChars.removeAll()
        quesChars.removeAll()
        offset.removeAll()
        newPosition.removeAll()
        ans.correct.removeAll()
        ques.correct.removeAll()
        ans.pos.removeAll()
        ques.pos.removeAll()
        let n = voca.count
        offset = [CGSize](repeating: .zero, count: n)
        newPosition = [CGSize](repeating: .zero, count: n)
        ans.correct = [Bool](repeating: false, count: n)
        ques.correct = [Bool](repeating: false, count: n)
        ans.pos = [CGRect](repeating: .zero, count: n)
        ques.pos = [CGRect](repeating: .zero, count: n)
        vocaSpeak = [Bool](repeating: false, count: n)
        let chars = Array(voca)
        let charSh = chars.shuffled()
        for i in charSh{ ansChars.append(String(i)) }
        for i in chars{ quesChars.append(String(i)) }
    }
    func updatePos(geometry:GeometryProxy,ptr:UnsafeMutablePointer<CGRect>){
        let pos = geometry.frame(in: .global)
        ptr.pointee = pos
    }
    func timerController(){
        if(!roundChanging){
            if(timeClock <= 0){
                self.timer?.invalidate()
                timeClock = 0
                return
            }
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (_) in
                if(self.timeClock <= 0){
                    self.timeClock = 0
                    showScorePage = true
                    print("timer remove.")
                    return
                }
                self.timeClock -= 0.5
                print("self.timeClock:\(self.timeClock)")
            }
        }
        else{
            self.timer?.invalidate()
        }
    }
    func nextRoundDelay(){
        roundCount += 1
        print("roundCount:\(roundCount)")
        roundChanging = true
        timerController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
            strSpeacker(str:currentVoca.French)
            roundChanging = false
            timerController()
        }
    }
    func imageExist(inName: String) -> Bool {
        if let _ = UIImage(named: inName) {
            return true
        }
        else {
            return false
        }
    }
    var rectOutsider:some View{
        RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black,lineWidth: 4)
                    .frame(width: 50, height: 100)
                    .overlay(Text(String(format:"%.1f", timeClock))
                                .font(.system(size:13, weight: .semibold,design: .monospaced))
                                .foregroundColor(.black))
    }
    var vocabularyImage:some View{
        Button(action: {
            strSpeacker(str: currentVoca.French,rate:0.025)
        }, label: {
            Image(currentVoca.fileName == "" ? "default" : currentVoca.fileName)
                .resizable()
                //.background(Color.white)
                .scaledToFit()
                .frame(width: 230, height: 200, alignment: .center)
                .background(Color.white)
                .clipped()
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/,width: 1)
        })
    }
}

struct GamePage_Previews: PreviewProvider {
    static var previews: some View {
        Landscape{
            GamePage(currentPage: .constant(Pages.GamePage),savePhotos:.constant(false))
        }
    }
}
