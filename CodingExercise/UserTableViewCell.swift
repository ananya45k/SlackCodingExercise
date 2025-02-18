//
//  UserTableViewCell.swift
//
//  Created by Slack Candidate on 2/17/25.
//

import UIKit


class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    private var currentDataTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 4
        avatarImageView.clipsToBounds = true
        
        nameLabel.font = UIFont(name: "Lato-Bold", size: 16)
        usernameLabel.font = UIFont(name: "Lato-Regular", size: 16)
        
        nameLabel.textColor = UIColor(hex: "#1D1C1D")
        usernameLabel.textColor = UIColor(hex: "#616061")
    }
    
    func setImage(from url: URL) {
        // Cancel any previous requests
        currentDataTask?.cancel()
        
        currentDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data), let self = self else { return }
            
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
        
        // Start the new request
        currentDataTask?.resume()
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized = String(hexSanitized.dropFirst())
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

