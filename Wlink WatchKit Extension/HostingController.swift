//
//  HostingController.swift
//  Wlink WatchKit Extension
//
//  Created by robert prescott on 11/27/19.
//  Copyright © 2019 bobcode. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<AnyView> {
    var mess: Mess!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.mess = (WKExtension.shared().delegate as! ExtensionDelegate).mess
    }
    
    override var body: AnyView {
        return AnyView(ContentView()
            .environmentObject(mess)
        )
    }
    
}
