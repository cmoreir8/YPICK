import SwiftUI

protocol AuthenticationFormProtocol{
    var formIsValid: Bool { get }
}

extension LoginView: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
        
    }
}

struct UnderlineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            configuration
                .padding(0)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .frame(maxWidth: 300, alignment: .leading)
        }
    }
}


struct LoginView: View {
    @Binding var isPresented: Bool // Binding to control the visibility of the login view
    @State private var email = ""
    @State private var password = ""
    @State private var isGuestLoggedIn = false
    @State private var isLocationSettingsSheetPresented = false
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var locationData: LocationData
    @State private var rotationAngle: Double = 0.0
    @State private var createAccount = false
    @State private var accountAlert = false
    @State private var isLoading = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    var body: some View {
        NavigationView {
            VStack {
                
                Image("wheel_1")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .rotationEffect(.degrees(rotationAngle))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 10.0).repeatForever(autoreverses: false)) {
                            rotationAngle = 360.0
                        }}
                
                Text("Login")

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
                    // Password text field with underline style
                    SecureField("Password", text: $password)
                        .textFieldStyle(UnderlineTextFieldStyle())
                        .padding()
                        .autocorrectionDisabled(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    Spacer()
                        .frame(width: 55)
                        }
                
                // Login as Guest button
                Button("Login") {
                    isLoading.toggle()
                    
                    Task {
                        do {
                            // Perform the asynchronous login
                            try await viewModel.signIn(withEmail: email, password: password) { success in
                                if success {
                                    // Introduce a 3-second delay after successful login
                              //      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        isPresented = false
                                        isGuestLoggedIn = true
                                     //   isLocationSettingsSheetPresented.toggle()
                                        isLoading.toggle()
                                        
                                 //   }
                                } else {
                                    // Login unsuccessful
                                    // Call showAlert closure from AuthViewModel
                                    
                                    viewModel.showAlert?("Login Failed", "Invalid email or password.")
                                    isLoading.toggle()
                                }
                            }
                        } catch {
                            // Handle any errors that occur during login
                            // For example, you could present an error message or log the error
                            print("Error during login: \(error)")
                            isLoading.toggle()
                        }
                    }
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .frame(maxWidth: 250, maxHeight: 40)
                .foregroundColor(.white)
                .background(Capsule().fill(Color.yellow))
                .opacity(formIsValid ? 1.0 : 0.5)
                
                .fullScreenCover(isPresented: $isLoading) {
                           // Show loading screen or activity indicator as a full screen cover
                           LoadingView()
                       }
                
                
                   Button("Create Account") {
                       createAccount = true
                   }
                   .frame(maxWidth: 250, maxHeight: 40)
                   .foregroundColor(.white)
                   .background(Capsule().fill(Color.orange))
                   .padding()
                
                .padding()
                .sheet(isPresented: $isLocationSettingsSheetPresented) {
                    LocationSettingsView(isSheetPresented: $isLocationSettingsSheetPresented, latitude: $latitude,longitude: $longitude)
                      //  .presentationDetents([.large,.medium,.fraction(0.4)])
                         
                }
                Button("Forgot Password") {
                 //   isPresented = false
                }
                .padding()
                .font(.system(size: 10))
               
            }
            .background(Color.indigo.opacity(0.25))
            
            .background(
                // Use a NavigationLink to navigate to ContentView when isGuestLoggedIn is true
                NavigationLink("", destination: SettingsView(), isActive: $isGuestLoggedIn)
                .opacity(0) // Hide the link
                
            )
            .fullScreenCover(isPresented: $createAccount){
                CreateAccountView()
            }
            .alert(isPresented: $accountAlert) {
                Alert(title: Text("Alert"), message: Text("Not valid email or password"), dismissButton: .default(Text("OK")))
            }
            
            .onAppear(perform: viewModel.signOut)

        }
        
    }
}
