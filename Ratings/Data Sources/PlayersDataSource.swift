//
//  PlayersDataSource.swift
//  Ratings
//
//  Created by 김종권 on 2021/05/05.
//

import UIKit

class PlayersDataSource: NSObject {
  // MARK: - Properties
  var players: [Player]

  static func generatePlayersData() -> [Player] {
    return [
      Player(name: "Bill Evans", game: "Tic-Tac-Toe", rating: 4),
      Player(name: "Oscar Peterson", game: "Spin the Bottle", rating: 5),
      Player(name: "Dave Brubeck", game: "Texas Hold 'em Poker", rating: 2)
    ]
  }

  // MARK: - Initializers
  override init() {
    players = PlayersDataSource.generatePlayersData()
  }

  // MARK: - Datasource Methods
  func numberOfPlayers() -> Int {
    players.count
  }

    func append(player: Player, to tableView: UITableView) {
        players.append(player)
        tableView.insertRows(at: [IndexPath(row: players.count-1, section: 0)], with: .automatic)
    }

    func remove(at indexPath: IndexPath, to tableView: UITableView) {
        players.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func edit(with button: UIBarButtonItem, to tableView: UITableView) {
        if tableView.isEditing {
            button.title = "Edit"
            tableView.setEditing(false, animated: true)
        } else {
            button.title = "Done"
            tableView.setEditing(true, animated: true)
        }
    }

    func swapByLongPress(with sender: UILongPressGestureRecognizer, to tableView: UITableView) {
        let longPressedPoint = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: longPressedPoint) else { return }

        struct BeforeIndexPath {
            static var value: IndexPath?
        }

        struct BeforeCellSnapshotView {
            static var value: UIView?
        }

        switch sender.state {
        case .began:
            BeforeIndexPath.value = indexPath

            // snapshot을 tableView에 추가
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            BeforeCellSnapshotView.value = cell.snapshotCellStyle()
            BeforeCellSnapshotView.value?.center = cell.center
            BeforeCellSnapshotView.value?.alpha = 0.0
            if let beforeCellSnapshotView = BeforeCellSnapshotView.value {
                tableView.addSubview(beforeCellSnapshotView)
            }

            // 원래의 cell을 hidden시키고 snapshot이 보이도록 설정
            UIView.animate(withDuration: 0.3) {
                BeforeCellSnapshotView.value?.center = longPressedPoint
                print(longPressedPoint)
                BeforeCellSnapshotView.value?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                BeforeCellSnapshotView.value?.alpha = 0.98
                cell.alpha = 0.0
            } completion: { (isFinish) in
                if isFinish {
                    cell.isHidden = true
                }
            }

        case .changed:
            BeforeCellSnapshotView.value?.center = longPressedPoint

            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {
                let beforeValue = players[beforeIndexPath.row]
                let afterValue = players[indexPath.row]
                players[beforeIndexPath.row] = afterValue
                players[indexPath.row] = beforeValue
                tableView.moveRow(at: beforeIndexPath, to: indexPath)

                BeforeIndexPath.value = indexPath
            }
        default:
            // 손가락을 떼면 indexPath에 셀이 나타나는 애니메이션
            guard let beforeIndexPath = BeforeIndexPath.value,
                  let cell = tableView.cellForRow(at: beforeIndexPath) else { return }
            cell.isHidden = false
            cell.alpha = 0.0

            // Snapshot이 사라지고 셀이 나타내는 애니메이션 부여
            UIView.animate(withDuration: 0.3) {
                BeforeCellSnapshotView.value?.center = cell.center
                BeforeCellSnapshotView.value?.transform = CGAffineTransform.identity
                BeforeCellSnapshotView.value?.alpha = 1.0
                cell.alpha = 1.0
            } completion: { (isFinish) in
                if isFinish {
                    BeforeIndexPath.value = nil
                    BeforeCellSnapshotView.value?.removeFromSuperview()
                    BeforeCellSnapshotView.value = nil
                }
            }

        }
    }

  func player(at indexPath: IndexPath) -> Player {
    players[indexPath.row]
  }
}

extension UIView {
    func snapshotCellStyle() -> UIView {
        let image = snapshot()
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

    private func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return image
    }
}
