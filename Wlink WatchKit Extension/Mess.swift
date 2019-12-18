//
//  Message.swift
//  Wlink WatchKit Extension
//
//  Created by robert prescott on 12/15/19.
//  Copyright © 2019 bobcode. All rights reserved.
//
import SwiftUI

class Mess: ObservableObject {
    @Published var messTitle = ""
    @Published var messMessage = ""
}
