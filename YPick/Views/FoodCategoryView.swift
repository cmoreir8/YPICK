import SwiftUI

struct FoodCategoryView: View {
    @Binding var selectedValue: Int
    let data = ["", "Indian", "Mexican", "Italian", "Japanese", "Chinese", "American", "Thai", "Mediterranean", "Vegetarian", "Vegan"]

    var body: some View {
        List {
            ForEach(data.indices, id: \.self) { index in
                NavigationLink(destination: Text("Selected: \(data[index])")) {
                    HStack {
                        Text(data[index] + " Restaurants")
                        Spacer()
                        if selectedValue == index {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .onTapGesture {
                    selectedValue = index
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
