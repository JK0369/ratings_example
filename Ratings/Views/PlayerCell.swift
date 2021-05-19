//
//  PlayerCell.swift
//  Ratings
//
//  Created by 김종권 on 2021/05/05.
//

import UIKit

class PlayerCell: UITableViewCell {

    static let identifier = "PlayerCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!

    var player: Player? {
      didSet {
        guard let player = player else { return }

        gameLabel.text = player.game
        nameLabel.text = player.name
        ratingImageView.image = image(forRating: player.rating)
      }
    }

    private func image(forRating rating: Int) -> UIImage? {
      let imageName = "\(rating)Stars"
      return UIImage(named: imageName)
    }
}
