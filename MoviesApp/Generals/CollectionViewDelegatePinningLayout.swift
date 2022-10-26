//
//  CollectionViewDelegatePinningLayout.swift
//  MoviesApp
//
//  Created by Jorge Garay on 25/10/22.
//

import UIKit

protocol CollectionViewDelegatePinningLayout: UICollectionViewDelegateFlowLayout {

    /// Should return vertical offset from reference item top edge where layout should start. The most common values
    /// are `collectionView.adjustedContentInset.top` to pin to top safe area edge or `0` to pin to top
    /// edge of collection view.
    func topEdgeInsetForPinning(_ collectionView: UICollectionView) -> CGFloat

    /// Should return index path of last item that should be pinned. Return `IndexPath(row: 0, section: 0)`
    /// to pin only first item.
    func referencePinnedItemIndexPath(_ collectionView: UICollectionView) -> IndexPath
}

final class CollectionViewPinningLayout: UICollectionViewFlowLayout {

    override var sectionHeadersPinToVisibleBounds: Bool {
        didSet { assert(!sectionHeadersPinToVisibleBounds) }
    }

    override var sectionFootersPinToVisibleBounds: Bool {
        didSet { assert(!sectionFootersPinToVisibleBounds) }
    }

    override func prepare() {
        super.prepare()
        preparePinnedItemsIfNeeded()
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        pinnedItemIndices = nil
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let pinnedItemIndices = self.pinnedItemIndices ?? []
        var visibleAttributes = super.layoutAttributesForElements(in: rect)?.filter { attributes -> Bool in
            return !pinnedItemIndices.contains(attributes.indexPath)
        } ?? []
        pinnedItemIndices
            .compactMap { indexPath -> UICollectionViewLayoutAttributes? in
                return self.layoutAttributesForItem(at: indexPath)
            }
            .filter {
                $0.frame.intersects(rect)
            }
            .forEach { attributes in
                visibleAttributes.append(attributes)
            }
        return visibleAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = layoutAttributesForPinnedItem(at: indexPath, zIndex: 100) {
            return attributes
        }
        return super.layoutAttributesForItem(at: indexPath)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: -

    private var delegate: CollectionViewDelegatePinningLayout {
        return collectionView!.delegate as! CollectionViewDelegatePinningLayout
    }

    private var pinnedItemIndices: [IndexPath]?

    private func layoutAttributesForPinnedItem(at indexPath: IndexPath, zIndex: Int) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView,
              pinnedItemIndices?.contains(indexPath) ?? false,
              let superAttributes = super.layoutAttributesForItem(at: indexPath),
              let attributes = superAttributes.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        let pinnedItems = self.pinnedItemIndices?.prefix {
            $0.section < indexPath.section || ($0.section == indexPath.section && $0.row < indexPath.row)
        } ?? []
        var topInset = delegate.topEdgeInsetForPinning(collectionView)
        pinnedItems
            .compactMap { indexPath -> CGRect? in
                return self.layoutAttributesForItem(at: indexPath)?.frame
            }
            .forEach { frame in
                topInset += frame.size.height
            }
        attributes.zIndex = zIndex
        attributes.frame.origin.y = max(attributes.frame.origin.y, collectionView.contentOffset.y + topInset)
        return attributes
    }

    private func preparePinnedItemsIfNeeded() {
        guard let collectionView = collectionView, pinnedItemIndices == nil else {
            return
        }
        pinnedItemIndices = preparePinnedItemIndices(collectionView)
    }

    private func preparePinnedItemIndices(_ collectionView: UICollectionView) -> [IndexPath] {
        guard collectionView.numberOfSections > 0 else {
            return []
        }
        let referenceCardItem = delegate.referencePinnedItemIndexPath(collectionView)
        var pinnedItems: [IndexPath] = []
        for section in stride(from: 0, through: referenceCardItem.section, by: 1) {
            for row in stride(from: 0, to: collectionView.numberOfItems(inSection: section), by: 1) {
                pinnedItems.append(IndexPath(row: row, section: section))
            }
        }
        return pinnedItems
    }
}
