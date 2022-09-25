//
//  Home.swift
//  FocS On
//
//  Created by Ali Erdem Kökcik on 25.09.2022.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        VStack{
            Text("Focs On")
                .fontWeight(.heavy)
                .font(.system(size: 32))
            
            GeometryReader{proxy in
                VStack(spacing: 15){
                    //Mark: Timer Ring
                    ZStack{
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-20)
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.03), lineWidth: 40)
                            .padding(-20)
                        
                        Circle()
                            .fill(Color("Background"))
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(Color("Pink"), lineWidth: 6)
                        //Knob
                        GeometryReader{proxy in
                            let size = proxy.size
                                
                            Circle()
                                .fill(Color("Pink"))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                        }
                        
                        Text(pomodoroModel.timerStringValue)
                            .font(.system(size: 30, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: pomodoroModel.progress)
                    }
                    .padding(70)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: pomodoroModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button{
                        if pomodoroModel.isStarted{
                            pomodoroModel.stopTimer()
                        }else{
                            pomodoroModel.addNewTimer = true
                        }
                    } label: {
                        Image(systemName: !pomodoroModel.isStarted ? "timer" : "pause")
                            .font(.largeTitle)
                            .foregroundColor(Color("Pink"))
                    }
                }
                .onTapGesture {
                    pomodoroModel.progress = 0.5
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding()
        .background{
            Color("Background")
                .ignoresSafeArea()
        }
        .overlay(content:{
            ZStack{
                Color.black
                    .opacity(pomodoroModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        pomodoroModel.hour = 0
                        pomodoroModel.minute = 0
                        pomodoroModel.seconds = 0
                        pomodoroModel.addNewTimer = false
                    }
                
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: pomodoroModel.addNewTimer ? 0 : 395)
            }
            .animation(.easeInOut, value: pomodoroModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()){
            _ in
            if pomodoroModel.isStarted{
                pomodoroModel.updateTimer()
            }
        }
        .alert("Congratulations!", isPresented: $pomodoroModel.isFinished){
            Button("Start New", role: .cancel){
                pomodoroModel.stopTimer()
                pomodoroModel.addNewTimer = true
            }
            Button("Close", role: .destructive){
                pomodoroModel.stopTimer()
            }
        }
    }
    
    //New timer bottom sheet
    @ViewBuilder
    func NewTimerView() -> some View{
        VStack(spacing: 15){
            Text("Add new timer")
                .fontWeight(.heavy)
                .font(.system(size: 20))
                .padding(.top, 10)
            
            HStack(spacing: 15){
                Text("\(pomodoroModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "hr"){value in
                            pomodoroModel.hour = value
                        }
                    }
                
                Text("\(pomodoroModel.minute) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "min"){value in
                            pomodoroModel.minute = value
                        }
                    }
                
                Text("\(pomodoroModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "sec"){value in
                            pomodoroModel.seconds = value
                        }
                    }
            }
            .padding(.top, 20)
            
            Button{
                pomodoroModel.startTimer()
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background{
                        Capsule()
                            .fill(Color("Pink"))
                    }
            }
            .disabled((pomodoroModel.seconds == 0))
            .opacity(pomodoroModel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("Background"))
                .ignoresSafeArea()
        }
    }
    
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int)-> ()) -> some View{
        ForEach(0...maxValue, id: \.self){value in
            Button("\(value) \(hint)"){
                onClick(value)
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroModel())
    }
}
