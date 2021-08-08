//
//  ViewModel.swift
//  URL Shorthener
//
//  Created by Jerry Leong on 02/08/2021.
//

import Foundation

struct Model: Hashable {
    let long: String
    let short : String
}

class ViewModel : ObservableObject {
    
    @Published var models = [Model]()
    
    func submit(urlString: String){
        guard URL(string: urlString) != nil else{
            return
        }
        
        // API Call
        guard let apiURL = URL(string: "https://api.1pt.co/addURL?long="+urlString.lowercased()) else{
            return
        }
        
        print(apiURL.absoluteString)
        
        let task = URLSession.shared.dataTask(with: apiURL) { [weak self] data, _, error in
            guard let data = data,error == nil else{
                return
            }
            //Convert data to JSON
            
            do{
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                print("RESULT: \(result)")
                let long = result.long
                let short = result.short
                DispatchQueue.main.async {
                    self?.models.append(.init(long: long, short: short))
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}





//https://api.1pt.co/addURL?long=https://apple.com


 // 20210802141057
 // https://api.1pt.co/addURL?long=https://apple.com

struct APIResponse: Codable{
    let status: Int
    let message: String
    let short: String
    let long: String
}


/*
 {
   "status": 201,
   "message": "Added!",
   "short": "sotoe",
   "long": "https://apple.com"
 }
 */
 
 
