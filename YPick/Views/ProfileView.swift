//
//  ProfileView.swift
//  YPick
//
//  Created by Chris Moreira on 12/2/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            List{
                Section{
                    HStack{
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height:72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        
                        VStack(alignment: .leading, spacing: 4){
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Section("General"){
                    HStack{
                        Image(systemName: "gear")
                        Text("Version")
                            .font(.subheadline)
                        Spacer()
                        Text("1.0.0")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                }
                Section("Account"){
                    HStack{
                        ZStack{
                            Image(systemName: "circle.fill")
                                .foregroundColor(.red)
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                        }
                        Button{
                            print("sign out")
                        }label:{
                            Text("Sign Out")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        
                    }
                    HStack{
                        
                        ZStack{
                            Image(systemName: "circle.fill")
                                .foregroundColor(.red)
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                        }
                        
                        Button{
                            print("Delete accouont")
                        }label:{
                            Text("Delete Account")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
