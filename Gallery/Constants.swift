//
//  Constants.swift
//  Gallery
//
//  Created by Saida Yessirkepova on 20.02.2023.
//

import Foundation
import UIKit


struct Constants {
    
    struct API {
        static let key = "33785706-b69214f9a5706dc07afb49dc2"
    }
    
    struct Identifiers {
        static let mediaCollectionViewCell = "MediaCollectionViewCell"
    }
    
    struct Links {
        static let baseURL = "https://pixabay.com/api/"
    }
    
    struct Values {
      static let sctreenWidth  = UIScreen.main.bounds.width
    }
    
    struct Colors {
        
      static let imageCell  = UIColor(red: 237/255, green: 248/255, blue: 235/255, alpha: 1)
        static let videoCell  = UIColor(red: 30/255, green: 107/255, blue: 223/255, alpha: 0.2)
    }
}

enum MediType: String  {
    case image = "Image"
    case video = "Video"
}
