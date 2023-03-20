//
//  APICaller.swift
//  Gallery
//
//  Created by Saida Yessirkepova on 20.02.2023.
//

import Foundation
import Alamofire

protocol APICallerDelegate {
    func didUpdateModelList(with modelList: [ImageModel])
    func didFailtWithError(_ error: Error)
}

struct APICaller {
    static var shared = APICaller()
    
    var delegate: APICallerDelegate?
    
    func fetchRequest(with query: String = "") {
            let urlString = "https://pixabay.com/api/?key=33785706-b69214f9a5706dc07afb49dc2&q=\(query)&image_type=photo&pretty=true"
        AF.request(urlString).response { response in
            switch response.result {
            case.success(let data):
                if let modelList = parseImageJSON(data!) {
                    delegate?.didUpdateModelList(with: modelList)
                }
            case .failure(let error):
                delegate?.didFailtWithError(error)
            }
            
        }
            
        
    }
    func parseImageJSON(_ data: Data) -> [ImageModel]? {
        var modelList: [ImageModel] = []
        do {
            let decodedData = try JSONDecoder().decode(ImageData.self, from: data)
            for imageData in decodedData.hits {
                let imageModel = ImageModel(previewURL: imageData.previewURL, largeImageUrl: imageData.largeImageURL)
                modelList.append(imageModel)
            }
        } catch {
         print(error)
        }
        return modelList
    }
        
}
