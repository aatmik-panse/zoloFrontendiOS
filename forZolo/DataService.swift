//
//  DataService.swift
//  forZolo
//
//  Created by Aatmik Panse on 25/12/23.
//

import Foundation

struct DataService{
    func getData() -> [MenuItem]{
        return [
            MenuItem(name: "Elon", by: "Naman", imageName: "elon"),
            MenuItem(name: "Steve", by: "Ram", imageName: "fan"),
            MenuItem(name: "Tata", by: "Raman", imageName: "elon"),
            MenuItem(name: "Steve", by: "Ram", imageName: "fan"),
            MenuItem(name: "Tata", by: "Raman", imageName: "elon")
        ]
    }
}
