//
//  ContentView.swift
//  FlagGuesser
//
//  Created by Bjørn Hoxmark on 27/02/2022.
//

import SwiftUI


struct FlagImage: View {
    var fileName: String
    
    var body: some View{
        Image(fileName)
            .renderingMode(.original)
            .resizable()
            .frame(minWidth: 80, idealWidth: 200, maxWidth: 250, minHeight: 80, idealHeight: 120, maxHeight: 150, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

struct MidBox: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var opacityOnIncorrect = 1.0
    @State private var correctTrigger = false
    @State private var showHardMode = false
    @State private var scoreTitle = ""
    @State private var counteries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Poland", "Russia", "Spain","Belgium", "Canada", "Chile", "China"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var correctFlag = ""
    @State private var clickedFlag = ""
    let s = " "
    let p = "+"
    
    @State private var animationAmount = 0.0

                      
    var body: some View {
        
        ZStack{
            RadialGradient(stops:[
                .init(color: Color(red:0.1, green:0.2, blue:0.49), location: 0.3),
                .init(color: Color(red:0.8, green:0.15, blue:0.25), location: 0.3)
            ], center: .top, startRadius: 100, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the flag!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 30){
                    VStack{
                        Text("Tap the right flag")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(counteries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                                        
                    ForEach(0..<3){number in
                        Button{
                            withAnimation {
                                animationAmount += 360
                                opacityOnIncorrect = 0.25
                            }
                            flagTapped(number)
                            
                            
                        }label: {
                            FlagImage(fileName: counteries[number])
                                .rotation3DEffect(.degrees((number == correctAnswer) ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity((number != correctAnswer) ? opacityOnIncorrect : 1)

                        }
                    }
                }.modifier(MidBox())

                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                Button{
                    swapMode()
                    score = 0
                } label: {
                    Text("Change to hard mode")
                }
            }.padding()
        }
        .alert(scoreTitle, isPresented: $showingScore ){
            Button("Continue", action: askQuestion)
            Link("Tell me more", destination: URL(string: "https://www.google.com/search?q=\(counteries[correctAnswer].replacingOccurrences(of: s, with: p))") ?? URL(string: "www.vg.no")!)

        } message: {
            Text("You clicked \(clickedFlag) - we asked for \(correctFlag).")
        }
        .alert("Hardmode!", isPresented: $showHardMode ){
        } message: {
            Text("Good luck!")
        }
        .alert("Correct!", isPresented: $correctTrigger ){
            Button("Next"){
                askQuestion()
            }
        }
    }
    
    func swapMode(){
        counteries = loadFile()
        showHardMode = true
    }
    
    func flagTapped(_ number: Int){
        if (number == correctAnswer) {
            scoreTitle = "Correct"
            score = score + 1
            askQuestion()
            correctTrigger = true
                        
        } else {
            scoreTitle = "False"
            correctFlag = counteries[correctAnswer]
            clickedFlag = counteries[number]
            showingScore = true
        }
    }

    
    func askQuestion() {
        opacityOnIncorrect = 1.0
        counteries.shuffle()
        correctAnswer = Int.random(in: 0..<2)
    }
    
    func loadFile()->[String]{
        if let fileURL = Bundle.main.url(forResource: "country_names", withExtension: "txt"){
            if let fileContents = try? String(contentsOf: fileURL){
                return fileContents.components(separatedBy: "\n")
            }
        }
        fatalError("Could not load country_names.txt file")

    }
            
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
