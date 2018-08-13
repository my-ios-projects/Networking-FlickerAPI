//
//  ViewController.swift
//  Flicker API
//
//  Created by Taha Magdy on 8/12/18.
//  Copyright © 2018 Taha Magdy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // UI Objects
    @IBOutlet weak var imageViewObject: UIImageView!
    @IBOutlet weak var getCarButton: UIButton!
    @IBOutlet weak var imageTitleLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func getCarAction(_ sender: Any) {
        setUIEnable(state: false)
        
        getImageFromFlickerAPI()
    }
    
    
    
    func getImageFromFlickerAPI() {
        
        // 1* Building the URL api
        let urlComponents = preparingURLusing_URLComponents()
        print(urlComponents.url!)

        
        // 2* Sending the Request
        // URLRequest is a wrapper over URL; it provides more request tools than URL does.
        let requestWithURL = URLRequest(url: urlComponents.url!)
        let request = URLSession.shared.dataTask(with: requestWithURL) {
            (data, reponse, error) in
            
            if error == nil, let data = data {
                
                let parsedJSON: AnyObject!
                // 2* We expect JSON in data; Serializing the row data into swift object.
                do {
                    parsedJSON = try JSONSerialization.jsonObject(with: data,
                                                              options: .allowFragments) as AnyObject
                } catch {
                    print("Catch; from the do parsing JSON")
                    return
                }
                
                

                // 3* Parsing it and take a random photo
                let photos = parsedJSON["photos"] as? [String: AnyObject]
                let photo = photos!["photo"] as? [AnyObject]
                print(photo!.count)
                let randomIndex = Int(arc4random_uniform(UInt32(photo!.count)))
                let onePhoto = photo![randomIndex] as? [String: AnyObject]

                
                // 3.1* Getting the image
                let imageURL = URL(string: onePhoto!["url_m"] as! String)

                
                // 4* Display
                if let imageData = try? Data(contentsOf: imageURL!) {
                    DispatchQueue.main.async {
                        self.imageViewObject.image = UIImage(data: imageData)
                        self.imageTitleLabel.text = onePhoto!["title"] as? String
                        self.setUIEnable(state: true)
                    }
                }

            } // end if let
            
        }
        // DO NOT FORGET IT.
        request.resume()

        
        
        

        
    } // end getImageFromFlickerAPI
    
    
    
    func preparingURLusing_URLComponents() -> URLComponents {
        /*
         # Here is how to use the URLComponents to build the URL of an API.
         */
        
        var urlObject = URLComponents()
        urlObject.scheme = "https"
        urlObject.host = "api.flickr.com"
        urlObject.path = "/services/rest/"
        
        // 1.1* preparing the query items
        urlObject.queryItems = [URLQueryItem]() // initializing items array.
        
        let key_item = URLQueryItem(name: "api_key", value: "938885d050539c1ea6fdbb194183bee9")
        let method_item = URLQueryItem(name: "method", value: "flickr.galleries.getPhotos")
        let extras_item = URLQueryItem(name: "extras", value: "url_m")
        let format_item = URLQueryItem(name: "format", value: "json")
        let gallary_item = URLQueryItem(name: "gallery_id", value: "5704-72157622637971865")
        let noJsonCallback_item = URLQueryItem(name: "nojsoncallback", value: "1")
        
        // 1.2* adding the url quey item in the queryItems array.
        urlObject.queryItems?.append(key_item)
        urlObject.queryItems?.append(method_item)
        urlObject.queryItems?.append(extras_item)
        urlObject.queryItems?.append(format_item)
        urlObject.queryItems?.append(gallary_item)
        urlObject.queryItems?.append(noJsonCallback_item)
        
        return urlObject
    }
    
    
    
    
    
    func setUIEnable(state: Bool){
        self.getCarButton.isEnabled = state
        if state {
            self.getCarButton.alpha = 1.0
        } else {
            self.getCarButton.alpha = 0.5
        }
    } // end setUIEnable
    
}
