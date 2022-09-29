//
//  NSCollectionViewLayout+VerticallCentered.swift
//  Movies
//
//  Created by Patrick Kladek on 29.09.22.
//

import UIKit

// from: https://stackoverflow.com/a/71335175
extension NSCollectionLayoutGroup {

    static func verticallyCentered(cellSizes: [CGSize], interItemSpacing: CGFloat = 10, interRowSpacing: CGFloat = 10) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        return custom(layoutSize: groupSize) { environment in
            var items: [NSCollectionLayoutGroupCustomItem] = []

            var yPos: CGFloat = environment.container.contentInsets.top

            var rowSizes: [CGSize] = []

            func totalWidth() -> CGFloat {
                rowSizes.map(\.width).reduce(0) {
                    $0 == 0 ? $1 : $0 + interItemSpacing + $1
                }
            }

            func addRowItems() {
                var xPos = (environment.container.effectiveContentSize.width - totalWidth())/2 + environment.container.contentInsets.leading
                let maxItemHeight = rowSizes.map(\.height).max() ?? 0
                let rowItems: [NSCollectionLayoutGroupCustomItem] = rowSizes.map {
                    let rect = CGRect(origin: CGPoint(x: xPos, y: yPos + (maxItemHeight - $0.height) / 2), size: $0)
                    xPos += ($0.width + interItemSpacing)
                    return NSCollectionLayoutGroupCustomItem(frame: rect)
                }

                items.append(contentsOf: rowItems)
            }

            for (index, cellSize) in cellSizes.enumerated() {
                rowSizes.append(cellSize)

                if totalWidth() > environment.container.effectiveContentSize.width {
                    rowSizes.removeLast()
                    addRowItems()
                    yPos += (cellSize.height + interRowSpacing)
                    rowSizes = [cellSize]
                }

                if index == cellSizes.count - 1 {
                    addRowItems()
                }
            }
            return items
        }
    }
}
