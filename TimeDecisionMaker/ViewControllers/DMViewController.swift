//
//  DMViewController.swift
//  TimeDecisionMaker
//
//  Created by Mikhail on 4/24/19.
//

import UIKit

class DMDefaultEvent: DMCalendarEvent {
    
    var startDate: Date
    var endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

class DMViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, DMCollectionViewLayoutDelegate {
    
    enum InteractionMode {
        case adding
        case editing
        case none
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var layout: DMCollectionViewLayout {
        return collectionView.collectionViewLayout as! DMCollectionViewLayout
    }
    
    private var events: [DMDefaultEvent] = []
    
    private var longPress: UILongPressGestureRecognizer!
    
    private var interactionMode = InteractionMode.none
    
    private var indexPathForInteractionItem: IndexPath?
    
    private var previousPoint: CGPoint?
    
    private var firstPoint: CGPoint?
    
    private var editingOffset: CGFloat = 0
    
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView.backgroundColor = UIColor.red
        events.append(contentsOf: [
            DMDefaultEvent(startDate: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date.today)!,
                           endDate: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date.today)!),
            DMDefaultEvent(startDate: Calendar.current.date(bySettingHour: 9, minute: 10, second: 0, of: Date.today)!,
                           endDate: Calendar.current.date(bySettingHour: 10, minute: 15, second: 0, of: Date.today)!),
            DMDefaultEvent(startDate: Calendar.current.date(bySettingHour: 11, minute: 5, second: 0, of: Date.today)!,
                           endDate: Calendar.current.date(bySettingHour: 13, minute: 45, second: 0, of: Date.today)!),
            DMDefaultEvent(startDate: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date.today)!,
                           endDate: Calendar.current.date(bySettingHour: 18, minute: 20, second: 0, of: Date.today)!),
            DMDefaultEvent(startDate: Calendar.current.date(bySettingHour: 19, minute: 35, second: 0, of: Date.today)!,
                           endDate: Calendar.current.date(bySettingHour: 20, minute: 20, second: 0, of: Date.today)!)
            ])
        
        
        print(events)
        
        
        collectionView.register(UINib(nibName: "DMHourView", bundle: nil), forSupplementaryViewOfKind: "hour", withReuseIdentifier: "hour")
        guard let layout = collectionView.collectionViewLayout as? DMCollectionViewLayout else { return }
        layout.delegate = self
        
        collectionView.reloadData()
        
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(onCalendarLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        
        
    }
    
    // MARK: Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("asd \(events.count)")
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DMCollectionViewCell
        cell.titleLabel.text = "F**** timesheets - \(indexPath.item)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "hour", withReuseIdentifier: "hour", for: indexPath) as! DMHourView
        view.titleLabel.text = "\(indexPath.item)"
        return view
    }
    
    // MARK: Collection view layout delegate
    
    func event(at indexPath: IndexPath) -> DMCalendarEvent {
        return events[indexPath.row]
    }
    
    func indexPathsOfEventsBetween(minHour: Int, maxHour: Int) -> [IndexPath] {
        return stride(from: 0, to: events.count, by: 1)
            .map({ IndexPath(item: $0, section: 0) })
    }
    
    // MARK: Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: nil)
    }

    @objc private func onCalendarLongPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        switch (gesture.state) {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: point) {
                interactionMode = .editing
                indexPathForInteractionItem = indexPath
                let startTimeInterval = events[indexPath.item].startDate.timeIntervalSince(Date.today)
                let timeIntervalForPoint = layout.timeIntervalAtOffset(point.y)
                let offsetInterval = timeIntervalForPoint - startTimeInterval
                editingOffset = CGFloat(offsetInterval) / CGFloat(layout.hourHeight)
            } else {
                let startTimeInterval = layout.timeIntervalAtOffset(point.y)
                let startDate = Date.today.addingTimeInterval(startTimeInterval)
                let endDate = startDate.addingTimeInterval(TimeInterval(30 * 60))
                
                let newEvent = DMDefaultEvent(startDate: startDate, endDate: endDate)
                events.append(newEvent)
                
                let newIndexPath = IndexPath(item: events.count - 1, section: 0)
                
                collectionView.insertItems(at: [newIndexPath])
                
                interactionMode = .adding
                indexPathForInteractionItem = newIndexPath
            }
            
            firstPoint  = point
            previousPoint = firstPoint
            
        case .changed:
            switch interactionMode {
            case .editing:
                if let previousPoint = previousPoint, abs(previousPoint.y - point.y) < layout.hourHeight / 4 {
                    break
                }
                previousPoint = point
                
                let offsetPoint = CGPoint(x: point.x, y: point.y - editingOffset)
                
                let event = events[indexPathForInteractionItem!.item]
                let startTimeInterval = layout.timeIntervalAtOffset(offsetPoint.y)
                let startDate = Date.today.addingTimeInterval(startTimeInterval)
                let endDate = startDate.addingTimeInterval(event.duration)
                let newEvent = DMDefaultEvent(startDate: startDate, endDate: endDate)
                
                events.remove(at: indexPathForInteractionItem!.item)
                events.insert(newEvent, at: indexPathForInteractionItem!.item)
                collectionView.reloadItems(at: [indexPathForInteractionItem!])
                
            case .adding:
                guard let firstPoint = firstPoint, firstPoint.y < point.y else { break }
                
                if let previousPoint = previousPoint, abs(previousPoint.y - point.y) < CGFloat(20) {
                    break
                }
                previousPoint = point
                
                let event = events[indexPathForInteractionItem!.item]
                let endTimeInterval = layout.timeIntervalAtOffset(point.y)
                let endDate = Date.today.addingTimeInterval(endTimeInterval)
                let newEvent = DMDefaultEvent(startDate: event.startDate, endDate: endDate)
                
                events.remove(at: indexPathForInteractionItem!.item)
                events.insert(newEvent, at: indexPathForInteractionItem!.item)
                collectionView.reloadItems(at: [indexPathForInteractionItem!])
                
            default: break
            }
            
        case .ended:
            interactionMode = .none
            indexPathForInteractionItem = nil
            
        case .cancelled, .failed:
            interactionMode = .none
            indexPathForInteractionItem = nil
            
        default: break
        }
    }
}

