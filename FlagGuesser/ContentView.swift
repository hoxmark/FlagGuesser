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
                    Text("Change mode")
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
        } message: {
            Text("Good luck!")
            
        }
    }
    
    func swapMode(){
        counteries = hardMode
        showHardMode = true
    }
    
    func flagTapped(_ number: Int){
        if (number == correctAnswer) {
            scoreTitle = "Correct"
            score = score + 1
//            askQuestion()
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
    
    var easyMode = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Zambia","Zimbabwe","Belgium", "Canada", "Chad", "Chile", "China"]
    
    var hardMode = ["Swaziland",
     "Turkey",
     "Iraq",
     "Peru",
     "Chad",
     "Djibouti",
     "Indonesia",
     "Singapore",
     "Uruguay",
     "Netherlands",
     "United States Minor Outlying Islands",
     "Austria",
     "Fiji",
     "Madagascar",
     "Egypt",
     "GB-SCT",
     "French Southern Territories",
     "Mayotte",
     "Brunei Darussalam",
     "Heard Island and McDonald Islands",
     "Christmas Island",
     "Northern Mariana Islands",
     "Slovenia",
     "Nicaragua",
     "Suriname",
     "Burundi",
     "United Kingdom",
     "Jersey",
     "Åland Islands",
     "Kiribati",
     "Svalbard and Jan Mayen",
     "Falkland Islands (Malvinas)",
     "Guinea",
     "Taiwan, Province of China",
     "Nigeria",
     "Curaçao",
     "Spain",
     "Malaysia",
     "Japan",
     "Argentina",
     "American Samoa",
     "Nepal",
     "Turkmenistan",
     "Cuba",
     "Jamaica",
     "New Zealand",
     "Bulgaria",
     "Georgia",
     "Croatia",
     "Tokelau",
     "Libya",
     "Sierra Leone",
     "Ethiopia",
     "Sudan",
     "Mali",
     "Lithuania",
     "Serbia",
     "Eritrea",
     "Russian Federation",
     "Macedonia, the Former Yugoslav Republic of",
     "Botswana",
     "Italy",
     "Belize",
     "Iran, Islamic Republic of",
     "Viet Nam",
     "Ukraine",
     "Congo, the Democratic Republic of the",
     "Isle of Man",
     "Saudi Arabia",
     "Germany",
     "Canada",
     "San Marino",
     "China",
     "Cambodia",
     "Norfolk Island",
     "Western Sahara",
     "Andorra",
     "Sri Lanka",
     "Sweden",
     "Paraguay",
     "Philippines",
     "Turks and Caicos Islands",
     "Liechtenstein",
     "Chile",
     "Burkina Faso",
     "Bahamas",
     "Somalia",
     "Bolivia, Plurinational State of",
     "South Africa",
     "Ghana",
     "Cyprus",
     "Nauru",
     "Kenya",
     "Dominica",
     "Central African Republic",
     "Afghanistan",
     "Virgin Islands, U.S.",
     "Slovakia",
     "Mozambique",
     "Panama",
     "Pitcairn",
     "South Georgia and the South Sandwich Islands",
     "Hong Kong",
     "Malta",
     "Belarus",
     "Ireland",
     "British Indian Ocean Territory",
     "Bonaire, Sint Eustatius and Saba",
     "Saint Lucia",
     "Saint Vincent and the Grenadines",
     "Niger",
     "Gambia",
     "Tunisia",
     "Mongolia",
     "Congo",
     "Antigua and Barbuda",
     "Guyana",
     "Guernsey",
     "Kyrgyzstan",
     "Macao",
     "Algeria",
     "United Arab Emirates",
     "Myanmar",
     "Anguilla",
     "Jordan",
     "Mauritania",
     "Kazakhstan",
     "Kuwait",
     "Cayman Islands",
     "Guadeloupe",
     "New Caledonia",
     "Dominican Republic",
     "Togo",
     "Sao Tome and Principe",
     "Portugal",
     "Gibraltar",
     "Israel",
     "Montserrat",
     "Lesotho",
     "Barbados",
     "Iceland",
     "Luxembourg",
     "Vanuatu",
     "Denmark",
     "Guinea-Bissau",
     "Morocco",
     "Angola",
     "Azerbaijan",
     "Palau",
     "Albania",
     "Maldives",
     "GB-NIR",
     "Réunion",
     "Tanzania, United Republic of",
     "Qatar",
     "Tajikistan",
     "Antarctica",
     "Bouvet Island",
     "Trinidad and Tobago",
     "Seychelles",
     "Cape Verde",
     "Bosnia and Herzegovina",
     "Tuvalu",
     "Wallis and Futuna",
     "Colombia",
     "Marshall Islands",
     "GB-WLS",
     "Faroe Islands",
     "Finland",
     "Equatorial Guinea",
     "Honduras",
     "Switzerland",
     "Guatemala",
     "Estonia",
     "Papua New Guinea",
     "Greenland",
     "Palestine, State of",
     "Cocos (Keeling) Islands",
     "Benin",
     "Zambia",
     "Micronesia, Federated States of",
     "Saint Kitts and Nevis",
     "Hungary",
     "Solomon Islands",
     "Martinique",
     "Moldova, Republic of",
     "Thailand",
     "Niue",
     "Cook Islands",
     "Poland",
     "Australia",
     "Saint Pierre and Miquelon",
     "Bhutan",
     "Brazil",
     "Cameroon",
     "Tonga",
     "Uganda",
     "Sint Maarten (Dutch part)",
     "Rwanda",
     "Holy See (Vatican City State)",
     "Armenia",
     "Yemen",
     "El Salvador",
     "Bangladesh",
     "French Polynesia",
     "Pakistan",
     "France",
     "Puerto Rico",
     "Bermuda",
     "Venezuela, Bolivarian Republic of",
     "French Guiana",
     "United States",
     "Zimbabwe",
     "Greece",
     "Mauritius",
     "Czech Republic",
     "Uzbekistan",
     "Oman",
     "Guam",
     "Latvia",
     "Virgin Islands, British",
     "Montenegro",
     "Monaco",
     "Timor-Leste",
     "Syrian Arab Republic",
     "Norway",
     "Belgium",
     "Costa Rica",
     "Bahrain",
     "Aruba",
     "Mexico",
     "South Sudan",
     "Senegal",
     "Lebanon",
     "Samoa",
     "Ecuador",
     "Comoros",
     "Romania",
     "Gabon",
     "Liberia",
     "Grenada",
     "Haiti",
     "India",
     "Malawi"
    ].shuffled()
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
