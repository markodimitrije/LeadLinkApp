//
//  UITableView+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension UITableView {
    
    func isCellBelowHalfOfTheScreen(cell: UITableViewCell) -> Bool {
        
        var cellPositionY = CGFloat.zero
        
        if let firstResponser = cell.findViews(subclassOf: UITextField.self).first {
            
            let firstResponserOneRowStackerView = firstResponser.superview(of: OneRowStacker.self)!
            cellPositionY = (cell.frame.origin.y + firstResponserOneRowStackerView.frame.origin.y) - self.contentOffset.y
        } else {
            let contentOffsetVertical = self.contentOffset.y
            cellPositionY = (cell.frame.origin.y - contentOffsetVertical)
        }
        
        return cellPositionY > UIScreen.main.bounds.midY
    }
    
    func getFirstCellBelow(cell: UITableViewCell) -> UITableViewCell? {
        
        var countOfCellsInSection = 0
        guard let actualIndexPath = self.indexPath(for: cell),
            let sectionIndex = self.indexPath(for: cell)?.section else {
                fatalError()
        }
                
        countOfCellsInSection = self.numberOfRows(inSection: sectionIndex)
        
        var newIp: IndexPath!
        if actualIndexPath.row + 1 < countOfCellsInSection {
            newIp = IndexPath(row: actualIndexPath.row + 1, section: actualIndexPath.section)
        } else {
            newIp = IndexPath(row: 0, section: actualIndexPath.section + 1)
        }
        return self.cellForRow(at: newIp)
    }
    
    func getFirstCellAbove(cell: UITableViewCell) -> UITableViewCell? {
        
        var countOfCellsInSection = 0
        guard let actualIndexPath = self.indexPath(for: cell),
            let sectionIndex = self.indexPath(for: cell)?.section else {
                fatalError()
        }
        
        countOfCellsInSection = self.numberOfRows(inSection: sectionIndex)
        
        var newIp: IndexPath!
        if isActualIndexSafe(actualIndexPath: actualIndexPath, countOfCellsInSection: countOfCellsInSection) {
            newIp = IndexPath(row: actualIndexPath.row - 1, section: actualIndexPath.section)
        } else {
            let lastIndexInPreviousSection = self.numberOfRows(inSection: sectionIndex - 1) - 1
            newIp = IndexPath(row: lastIndexInPreviousSection, section: actualIndexPath.section - 1)
        }
        return self.cellForRow(at: newIp)
    }
    
    private func isActualIndexSafe(actualIndexPath: IndexPath, countOfCellsInSection: Int) -> Bool {
        return actualIndexPath.row + 1 <= countOfCellsInSection && actualIndexPath.row - 1 >= 0
    }
}
