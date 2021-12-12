//
//  TextFildes.swift
//  LoginByFireBase2
//
//  Created by Abdullah Alnutayfi on 26/01/2021.
//

import Foundation
import SwiftUI
struct TextFields : ViewModifier{
    func body(content: Content) -> some View {
       
        content
            .padding(10)
            .border(Color(.systemGreen))
           // .frame(width: 300, height: 40)
           
        }
    
    
   
}

struct Buttons : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 100, height: 40)
            .background(Color(.systemGreen))
            .foregroundColor(.white)
            .font(Font.system(size: 18, weight: .bold, design: .default))
            .cornerRadius(10)
    }
}
