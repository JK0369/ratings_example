//
//  GamePickerViewController.swift
//  Ratings
//
//  Created by 김종권 on 2021/05/06.
//

import UIKit

class GamePickerViewController: UITableViewController {
  let gamesDataSource = GamesDataSource()
}

// MARK: - UITableViewDataSource
extension GamePickerViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    gamesDataSource.numberOfGames()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
    cell.textLabel?.text = gamesDataSource.gameName(at: indexPath)

    if indexPath.row == gamesDataSource.selectedGameIndex {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }

    return cell
  }
}

// MARK: - UITableViewDelegate
extension GamePickerViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 셀을 선택할 경우 나타나는 회색 배경 제거
    tableView.deselectRow(at: indexPath, animated: true)

    // 이전에 선택한 cell의 checkmark UI 제거
    if let index = gamesDataSource.selectedGameIndex {
      let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
      cell?.accessoryType = .none
    }

    // dataSource에서 새 게임 선택
    gamesDataSource.selectGame(at: indexPath)

    // checkmark UI 표출
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .checkmark

    performSegue(withIdentifier: "unwind", sender: cell)
  }
}
