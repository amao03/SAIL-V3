//
//  TestSetupView.swift
//  v2
//
//  Created by Lucas Drummond on 2/26/24.
//
import SwiftUI


struct TestSetupView: View {
    @Binding var subjectId: String
    @Binding var selectProtocol: Protocols
    var hasActiveTest: Bool
    
    var body: some View {
        Section {
            TextField(
                "Subject ID*",
                text: $subjectId
            )
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .disabled(hasActiveTest)
            
            Picker("Protocol:", selection: $selectProtocol) {
                ForEach(ProtocolList.protocolList) { item in
                    Text(item.name)
                }
            }
            .disabled(hasActiveTest)
            
            NavigationLink {
                Text("Watch Haptics View")
            } label: {
                Text("Watch Haptics")
            }

        } header: {
            Text("Test Setup")
        } footer: {
//            if(subjectId.isEmpty) {
//                Text("Subject ID is required to start a test")
//                    .foregroundColor(.blue)
//            }
        }
        .opacity(!hasActiveTest ? 1 : 0.5)
        
    }
}
