//
//  RBTreeNode+RangeNode.swift
//  RangeNode extensions for RedBlackTree
//
//  Created by Ilia Sazonov on 11/26/23.
//

import Foundation
import OSLog


extension RBTreeNode where T == RangeNode {
    public var isActualLeaf: Bool { key != nil && (leftChild?.isNullLeaf ?? true) && (rightChild?.isNullLeaf ?? true) }

    // Check if ranges should be merged
    public func shouldMergeWith(node: RBTreeNode<RangeNode>) -> Bool {
        // Ranges are adjacent if the end of one is exactly one less or more than the start of the other
        guard let thisKey = self.key, let otherKey = node.key else { return false }
        return (thisKey.end == otherKey.start || otherKey.end == thisKey.start) && thisKey.count == otherKey.count
    }

    // Check if ranges should be split
    // |--------------|
    //    |----|
    //
    // |--------------|
    //     |--------------|

    func shouldSplitWith(node: RBTreeNode<RangeNode>) -> Bool {
        // Ranges overlap if they are not completely separate
        guard let thisKey = self.key, let otherKey = node.key else { return false }
        return thisKey.end > otherKey.start && thisKey.start < otherKey.end
    }

    // Split a range based on overlap
//    func splitWith(node: RBTreeNode<RangeNode>) -> [RangeNode] {
    func splitWith(node: RBTreeNode<RangeNode>) -> (RangeNode?, RangeNode, RangeNode?)? {
        guard let thisKey = self.key, let otherKey = node.key else { return nil }

        var newNodes = [RangeNode]()
        // Split left part
        var leftPart: RangeNode? = nil
        if thisKey.start < otherKey.start {
            leftPart = RangeNode(start: thisKey.start, end: otherKey.start, count: thisKey.count)
        } else if otherKey.start < thisKey.start {
            leftPart = RangeNode(start: otherKey.start, end: thisKey.start, count: thisKey.count)
        }

        var middlePart: RangeNode
        // Middle overlapping part
        let overlappingStart = max(thisKey.start, otherKey.start)
        let overlappingEnd = min(thisKey.end, otherKey.end)
        middlePart = RangeNode(start: overlappingStart, end: overlappingEnd, count: thisKey.count + otherKey.count)

        // Split right part
        var rightPart: RangeNode? = nil
        if thisKey.end > otherKey.end {
            rightPart = RangeNode(start: otherKey.end, end: thisKey.end, count: thisKey.count)
        } else if otherKey.end > thisKey.end {
            rightPart = RangeNode(start: thisKey.end, end: otherKey.end, count: thisKey.count)
        }
        return (leftPart, middlePart, rightPart)
    }
}


