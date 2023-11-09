//
//  ContentView.swift
//  twenty five plus five
//
//  Created by Михаил Куприянов on 9.11.23..
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        VStack {
            Home()
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

struct Home: View {
    @State var start = false
    @State var to: CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(.white.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)
                    Circle()
                        .trim(from: 0, to: to)
                        .stroke(.purple ,style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)
                        .rotationEffect(.init(degrees: -90))
                    VStack{
                        Text("\(count)")
                            .font(.system(size: 65))
                            .bold()
                        Text("Of 15")
                            .font(.title)
                    }
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        if count == 15 {
                            count = 0
                            withAnimation(.default) {
                                to = 0
                            }
                        }
                        start.toggle()
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: start ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                            Text(start ? "Pause" : "Play")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(.purple)
                        .clipShape(Capsule())
                    }
                    Button(action: {
                        count = 0
                        withAnimation(.default) {
                            to = 0
                        }
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.white)
                            Text("Restart")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(
                            Capsule()
                                .stroke(.purple, lineWidth: 2)
                        )
                    }
                }
                .padding(.top, 55)
            }
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.badge, .sound, .alert]) { _, _ in
                    
                }
        })
        .onReceive(time, perform: { _ in
            if start {
                if count != 15 {
                    count += 1
                    withAnimation(.default) {
                        to = CGFloat(count) / 15
                    }
                } else {
                    start.toggle()
                    Nt()
                }
            }
        })
    }
    
    func Nt() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.title = "Timer"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
}

/*
 нужен 1 таймер на 25 секунд,
 после запускается второй таймер на 5 секунд
 первый таймер работа/учеба - постараться добраться до фокуса телефона
 второй таймер отдых - так же все в режиме фокуса,
 напоминание не брать телефон, соц сети, а походить, посмотреть в окно, выпить/налить чаю
 оба таймера дают сигнал звуком/вибрацией
 оба таймера изменяемы по времени и звуковому сигналу
 цикл обоих таймеров (25+5) можно обернуть в общий длинный период - например учеба или работа
 общий период можно привязать к расписанию, сделать его запуск автоматическим, с предупреждением перед началом периода по расписанию, например за 10 или 5 минут - типо через 10 минут запланирована учеба, приготовьтесь
 должна быть возможность отложить/перенести/отменить период
 запуск, управление голосом, через Сири?
 
 три круга
 - общий период в несколько часов
 в общем круге можно разными цветами, соответственно прошедшим и запланированным периодам отображать циклы работы и отдыха в текущем общем периоде
 - внутренний круг - показывает остаток текущего периода,
 разного цвета для учебы/отдыха с отчетом времени по центру
 - нажатие на центр запускает/останавливает таймеры
 надо как то визуализировать это
 - центре показывать общее время периодов/прошло/осталось
 
 настройки
 - таймеров - жестами, пальцем и через настройки колесом time
 - звука и вибрации
 - цветов кругов
 - наименований кругов
 - постараться управлять режимом телефона(фокус)
 
 виджет для телефона/мака/часов с управлением
 
 для инклюзивных + локализация
 
 */
