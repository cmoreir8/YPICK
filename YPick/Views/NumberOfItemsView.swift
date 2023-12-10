import SwiftUI

struct NumberOfItemsView: View {
    @Binding var selectedValue: Int
    let data = 2...10

    var body: some View {
        HStack {
            Stepper(value: $selectedValue, in: data) {
                Text("\(selectedValue) Restaurants")
                    .font(.system(size: 12))
                    .frame(width: 100)
                    .background(Color.clear)
            }
        }
    }
}

