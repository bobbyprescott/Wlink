//
//  BobView.swift
//  Wlink WatchKit Extension
//
//  Created by robert prescott on 12/16/19.
//  Copyright © 2019 bobcode. All rights reserved.
//

import SwiftUI

struct BobView: View {
    @EnvironmentObject var mess: Mess
    @State private var isDone = false
    
    var body: some View {
        VStack{
            Text(mess.messTitle)
            Toggle(isOn:$isDone) {
                Text("Done")
            }
        }
    }}

struct BobView_Previews: PreviewProvider {
    static var previews: some View {
        BobView()
    }
}
