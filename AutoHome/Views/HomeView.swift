//
//  HomeView.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/24/21.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeModel = HomeModel()

    var body: some View {
        VStack {
//            List(home.relays) { relay in
//                HStack {
//                    Text(relay.name)
//                        .padding()
//
//                    Button {
//                        home.toggleRelay(id: relay.id)
//                    } label: {
//                        ZStack{
//                            Capsule()
//                                .foregroundColor(.blue)
//                                .frame(width:100, height:40)
//                            Text("Toggle")
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                    }
//                }
//            }
            Form {
                ForEach($homeModel.relays) { $relay in
                    Toggle(relay.name, isOn: $relay.on)
                        .onChange(of: relay.on) { value in
                            homeModel.setRelayModelOn(id: relay.id, on: value)
                        }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
