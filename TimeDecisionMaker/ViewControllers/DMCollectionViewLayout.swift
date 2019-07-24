//
//  DMCollectionViewLayout.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 7/22/19.
//

import Foundation
import UIKit

protocol DMCalendarEvent {
    
    var startDate: Date { get }
    var endDate: Date { get }
    
}

extension DMCalendarEvent {
    
    var duration: TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
}

protocol DMCollectionViewLayoutDelegate: class {
    
    func event(at indexPath: IndexPath) -> DMCalendarEvent
    func indexPathsOfEventsBetween(minHour: Int, maxHour: Int) -> [IndexPath]
}

class DMCollectionViewLayout: UICollectionViewLayout {

    weak var delegate: DMCollectionViewLayoutDelegate?
    
    
    var hours: UInt = 24
    var hourHeight: CGFloat = 80
    
    
    
    override init() {
        super.init()
            registerDecorationViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            registerDecorationViews()
    }
    
    override var collectionViewContentSize: CGSize {
        let width = collectionView?.bounds.width ?? 0
        let height = CGFloat(hours) * hourHeight
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        let eventsIndexPaths = indexPathsForVisibleEvents(in: rect)
        for indexPath in eventsIndexPaths {
            if let attributes = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attributes)
            }
        }
        
        let hoursIndexPaths = indexPathsForVisibleHours(in: rect)
        for indexPath in hoursIndexPaths {
            if let attributes = layoutAttributesForSupplementaryView(ofKind: "hour", at: indexPath) {
                layoutAttributes.append(attributes)
            }
        }
        
        let currentTimeIndexPath = indexPathForCurrentTime()
            if let attributes = layoutAttributesForDecorationView(ofKind: "currentTime", at: currentTimeIndexPath) {
                layoutAttributes.append(attributes)
            }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let event = delegate!.event(at: indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame(for: event)
        attributes.zIndex = 1
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attributes.frame = frame(forHour: indexPath.item)
        return attributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == "currentTime" {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
            attributes.frame = frameForCurrentTime()
            attributes.zIndex = 2
            return attributes
        }
        return nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public func timeIntervalAtOffset(_ offset: CGFloat) -> TimeInterval {
        let timeInterval = TimeInterval(offset / hourHeight) * 60 * 60
        return timeInterval
    }
    
    private func frame(for event: DMCalendarEvent) -> CGRect {
        let components = Calendar.current.dateComponents([.hour, .minute], from: event.startDate)
        let hourY = hourHeight * CGFloat(components.hour!)
        let minuteY = hourHeight * CGFloat(components.minute!) / 60
        
        let x: CGFloat = 60
        let y: CGFloat = hourY + minuteY
        let width: CGFloat = collectionViewContentSize.width - x - 10
        let height: CGFloat = hourHeight * CGFloat(event.duration / 3600)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func frame(forHour hour: Int) -> CGRect {
        let x: CGFloat = 00
        let y: CGFloat = hourHeight * CGFloat(hour)
        let width: CGFloat = collectionViewContentSize.width
        let height: CGFloat = 40
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func frameForCurrentTime() -> CGRect {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let hourY = hourHeight * CGFloat(components.hour!)
        let minuteY = hourHeight * CGFloat(components.minute!) / 60
        
        let x: CGFloat = 0
        let y: CGFloat = hourY + minuteY
        let width: CGFloat = collectionViewContentSize.width
        let height: CGFloat = 3
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func indexPathsForVisibleEvents(in rect: CGRect) -> [IndexPath] {
        let minHour = Int(floor(rect.minY / hourHeight))
        let maxHour = Int(ceil(rect.maxY / hourHeight))
        
        return delegate!.indexPathsOfEventsBetween(minHour: minHour, maxHour: maxHour)
    }
    
    private func indexPathsForVisibleHours(in rect: CGRect) -> [IndexPath] {
        let minHour = Int(floor(rect.minY / hourHeight))
        let maxHour = Int(ceil(rect.maxY / hourHeight))
        
        return stride(from: minHour, to: maxHour, by: 1).map({ IndexPath(item: $0, section: 0) })
    }
    
    private func indexPathForCurrentTime() -> IndexPath {
        return IndexPath(item: 0, section: 0)
    }
    
    private func registerDecorationViews() {
        register(UINib(nibName: "CurrentTimeDecorationView", bundle: nil), forDecorationViewOfKind: "currentTime")
    }

}
