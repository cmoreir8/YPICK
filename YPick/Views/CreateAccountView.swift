//
//  CreateAccountView.swift
//  YPick
//
//  Created by Chris Moreira on 12/2/23.
//

import SwiftUI


extension CreateAccountView: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5 && !fullname.isEmpty && confirmPassword == password
        
    }
}


struct CreateAccountView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vievModel: AuthViewModel
    var body: some View {
        VStack{
            
            Image("firebase")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            
            HStack {
                Spacer()
                    .frame(width: 55)
                TextField("Email Address", text: $email)
                    .textFieldStyle(UnderlineTextFieldStyle())
                    .padding()
                    .autocorrectionDisabled(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                Spacer()
                    .frame(width: 50)
                    }
            
            HStack {
                Spacer()
                    .frame(width: 55)
                TextField("Full Name", text: $fullname)
                    .textFieldStyle(UnderlineTextFieldStyle())
                    .padding()
                    .autocorrectionDisabled(true)
                
                Spacer()
                    .frame(width: 50)
                    }
            
            HStack {
                Spacer()
                    .frame(width: 55)
                // Password text field with underline style
                SecureField("Password", text: $password)
                    .textFieldStyle(UnderlineTextFieldStyle())
                    .padding()
                    .autocorrectionDisabled(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                Spacer()
                    .frame(width: 55)
                    }
            ZStack(alignment: .trailing){
                HStack {
                    Spacer()
                        .frame(width: 55)
                    // Password text field with underline style
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(UnderlineTextFieldStyle())
                        .padding()
                        .autocorrectionDisabled(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    Spacer()
                        .frame(width: 55)
                }
                if !password.isEmpty && !confirmPassword.isEmpty {
                    if password == confirmPassword {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGreen))
                    } else{
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemRed))
                        
                    }
                }
            }
            
            Spacer()
            
            Button("SIGN UP") {
                Task{
                    try await vievModel.createUser(withEmail:email, password:password, fullname: fullname)
                }
                dismiss()
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .frame(maxWidth: 300, maxHeight: 50)
            .foregroundColor(.white)
            .background(Capsule().fill(Color.yellow).onTapGesture {
              
            })
            Spacer()
            Button("CANCEL"){
                dismiss()
            }
        }
       
    }
}

#Preview {
    CreateAccountView()
}
