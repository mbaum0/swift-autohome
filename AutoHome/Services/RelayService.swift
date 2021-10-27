//
//  RelayService.swift
//  AutoHome
//
//  Created by Michael Baumgarten on 10/26/21.
//

import Foundation

class RelayService {
    /**
     * Interact with the Shelly relay API
     * @return True is the operation was succesful, False otherwise
     */
    @available(iOS 15.0.0, *)
    func setRelayOn(relay: Relay, on:Bool) async -> Bool? {
        var urlComp = URLComponents(string:"http://" + relay.ip + "/relay/0")
        urlComp?.queryItems = [URLQueryItem(name: "turn", value: on ? "on" : "off")]
        let url = urlComp?.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
    }
}

func downloadImageAndMetadata(imageNumber: Int) async throws -> DetailedImage {

     // Attempt to download the image first.
     let imageUrl = URL(string: "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part1/\(imageNumber).png")!
     let imageRequest = URLRequest(url: imageUrl)
     let (imageData, imageResponse) = try await URLSession.shared.data(for: imageRequest)
     guard let image = UIImage(data: imageData), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
         throw ImageDownloadError.badImage
     }

     // If there were no issues, continue downloading the metadata.
     let metadataUrl = URL(string: "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part1/\(imageNumber).json")!
     let metadataRequest = URLRequest(url: metadataUrl)
     let (metadataData, metadataResponse) = try await URLSession.shared.data(for: metadataRequest)
     guard (metadataResponse as? HTTPURLResponse)?.statusCode == 200 else {
         throw ImageDownloadError.invalidMetadata
     }

     let detailedImage = DetailedImage(image: image, metadata: try JSONDecoder().decode(ImageMetadata.self, from: metadataData))

     return detailedImage
 }
