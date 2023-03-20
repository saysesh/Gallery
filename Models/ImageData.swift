//
//  ImageData.swift
//  Gallery
//
//  Created by Saida Yessirkepova on 20.02.2023.
//

import Foundation
struct ImageData: Decodable {
    let hits: [Hit]
    
    struct Hit: Decodable {
        let previewURL: String
        let largeImageURL: String
        
    }
}
