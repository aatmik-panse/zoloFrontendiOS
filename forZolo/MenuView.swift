//
//  MenuView.swift
//  forZolo
//
//  Created by Aatmik Panse on 25/12/23.
//

import SwiftUI
struct MenuView: View {
    @State var menuItems: [MenuItem] = [MenuItem] ()
    var dataService=DataService()
    var body: some View {
    
        List ($menuItems) { item in
    HStack {
//        Image (item.imageName)
//            .resizable()
//            .aspectRatio (contentMode: .fit)
//            .frame (height: 50)
//            .cornerRadius (10)
        Text (item.name)
            .bold ()
        Spacer ()
        Text("$" + item.name)
            .listRowSeparator(.hidden)
            .listRowBackground (
                Color (. brown)
                    .opacity (0.1)
                    .istStyle(.plain))
            .onAppear{
                menuItems=dataService.getData()
            }
        }
    }
}
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
