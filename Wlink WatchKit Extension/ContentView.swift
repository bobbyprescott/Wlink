//
//  Using SwiftUI so the data binding is interesting
//  I used an @EnvironmentObject
//
//
//
//

import WatchKit
import Foundation
import SwiftUI

struct Person: Codable {
    let PersonId: Int?
    let FirstName: String?
    let LastName: String?
    let NotificationID: String?
    
    init(PersonId: Int, FirstName: String, LastName: String, NotificationID: String) {
        self.PersonId = PersonId
        self.FirstName = FirstName
        self.LastName = LastName
        self.NotificationID = NotificationID
    }
}

struct ContentView: View {
    @EnvironmentObject var mess: Mess
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var notificationid = ""
    @State private var whatname = ""
    @State private var buttonText = "Register Name"
    let temp = UserDefaults.standard
    
    var body: some View {
        Form {
            
            if(mess.messTitle != ""){
                BobView()
            } else{
                Section(header: Text("Register for notifications")) {
                    TextField("Firstname",
                              text: $firstname)
                    TextField("Lastname",
                              text: $lastname)
                    
                    Button(action: {
                        if(self.temp.value(forKey: "firstname") == nil){
                            if self.temp.value(forKey: "NotificationID") == nil{
                                self.temp.setValue("No notice ID", forKey: "NotificationID")
                            } else {
                                self.notificationid = self.temp.value(forKey: "NotificationID") as! String
                            }
                            let person = Person(PersonId: 0, FirstName: self.firstname,LastName: self.lastname,NotificationID: self.notificationid)
                            let postRequest = APIRequest(loc: "person")
                            postRequest.save(person, completion: { result in
                                switch result{
                                case .success(let person):
                                    let temp = UserDefaults.standard
                                    temp.setValue(self.firstname, forKey: "firstname")
                                    temp.setValue(self.lastname, forKey: "lastname")
                                    self.temp.synchronize()
                                    self.buttonText = "Remove Name"
                                        
                                case .failure(let error):
                                    print("Error \(error)")
                                }
                            })
                        } else {
                            self.buttonText = "Remove Name"
                            self.temp.removeObject(forKey: "firstname")
                            self.temp.removeObject(forKey: "lastname")
                            self.temp.removeObject(forKey: "NotificationID")
                            self.temp.synchronize()
                        }
                        
                    }, label: {
                        Text(buttonText)
                    })
                    
                }
                
                
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
