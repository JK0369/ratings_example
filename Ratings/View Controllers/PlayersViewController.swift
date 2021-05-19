//
//  PlayersViewController.swift
//  Ratings
//
//  Created by 김종권 on 2021/05/05.
//

import UIKit

class PlayersViewController: UITableViewController {
  var playersDataSource = PlayersDataSource()

    @IBAction func didTapEditButton(_ sender: UIBarButtonItem) {
        playersDataSource.edit(with: sender, to: tableView)
    }

    @IBAction func didLongPressCell(_ sender: UILongPressGestureRecognizer) {
        playersDataSource.swapByLongPress(with: sender, to: tableView)
    }
}

// MARK: - UITableViewDataSource
extension PlayersViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    playersDataSource.numberOfPlayers()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifier) as! PlayerCell
    cell.player = playersDataSource.player(at: indexPath)
    return cell
  }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playersDataSource.remove(at: indexPath, to: tableView)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    }

}

extension PlayersViewController {
  @IBAction func cancelToPlayersViewController(_ segue: UIStoryboardSegue) {
  }

  @IBAction func savePlayerDetail(_ segue: UIStoryboardSegue) {
    guard
      let playerDetailsViewController = segue.source as? PlayerDetailsViewController,
      let player = playerDetailsViewController.player
      else {
        return
    }
    playersDataSource.append(player: player, to: tableView)
  }
}
