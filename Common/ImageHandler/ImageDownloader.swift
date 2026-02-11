import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
/*
func secureURL(from originalURL: URL)-> URL{
    guard originalURL.scheme == "http" else { return originalURL}
    var components = URLComponents(url: originalURL, resolvingAgainstBaseURL: false)
    components?.scheme = "https"
    return components?.url ?? originalURL
}
*/

extension UIImageView {
    func loadImage(from url: URL?) {
        guard let url = url else { return }
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        self.image = nil
        //let securedURL = secureURL(from: url)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error{
                print("Image download error:", error.localizedDescription)
                return
            }
            guard let data = data, let downloadedImage = UIImage(data: data)
            else {
                return
            }
            print("URL to image:", url)
            ImageCache.shared.setObject(downloadedImage, forKey: cacheKey)
            DispatchQueue.main.async {
                self?.image = downloadedImage
            }
        }.resume()
    }
}
