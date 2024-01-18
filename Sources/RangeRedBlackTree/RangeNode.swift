//
//  RangeNode.swift
//  RangeNode extensions for RedBlackTree
//
//  Created by Ilia Sazonov on 12/14/23.
//

import Foundation
import OSLog


extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let rbtree = Logger(subsystem: subsystem, category: "redblacktree")
}

// Define RangeNode
public struct RangeNode: Comparable, CustomStringConvertible {
    // the range is defined as a right open one, i.e. the start is included in the range, and the end is not
    // range = (start ..< end), range length = end-start
    public var start: UInt32
    public var end: UInt32
    public var count: Int

    public var length: UInt32 { end - start }
    public var isZeroRange: Bool { end == start }

    public static func < (lhs: RangeNode, rhs: RangeNode) -> Bool {
        return lhs.end < rhs.start || lhs.end == rhs.start && lhs.count != rhs.count
    }

    public static func > (lhs: RangeNode, rhs: RangeNode) -> Bool {
        return lhs.start > rhs.end || lhs.start == rhs.end && lhs.count != rhs.count
    }

    // range equality
    public static func == (lhs: RangeNode, rhs: RangeNode) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }

    // overlap operator, this includes adjacency
    public static func ~= (lhs: RangeNode, rhs: RangeNode) -> Bool {
        return (rhs.start >= lhs.start && rhs.start <= lhs.end
            || lhs.start >= rhs.start && lhs.start <= rhs.end)
        && lhs != rhs
    }

    public static func gap(lhs: RangeNode, rhs: RangeNode) -> RangeNode {
        if lhs.end < rhs.start {
            return RangeNode(start: lhs.end, end: rhs.start, count: 1)
        } else if rhs.end < lhs.start {
            return gap(lhs: rhs, rhs: lhs)
        } else {
            // they overlap
            return RangeNode(start: 0, end: 0, count: 1)
        }
    }

    public func gap(with another: RangeNode) -> RangeNode {
        RangeNode.gap(lhs: self, rhs: another)
    }

    public init(start: UInt32, end: UInt32, count: Int) {
        self.start = start
        self.end = end
        self.count = count
    }

    public var description: String {
        "(start: \(start), end: \(end), length: \(length), count: \(count))"
    }
}

extension RangeNode {
    /// From an input array of ranges, builds a tuple of:
    /// (1) an array of contigues ranges by merging overlapping input ranges
    /// (2) gaps between the merged and non-merged nodes
    public static func buildContigs(from input: [RangeNode]) -> ([RangeNode], [RangeNode]) {
        var contigs = [RangeNode]()
        var gaps = [RangeNode]()
        guard input.count > 1 else { return (input, gaps) }
        let sortedInput = input.sorted(by: {$0.start < $1.start})
        var mergedRange = sortedInput[0]
        var i = 1
        while i < sortedInput.count {
//            Logger.rbtree.debug("------ iteration \(i) -------")
            if sortedInput[i] ~= mergedRange {
//                Logger.rbtree.debug("\(sortedInput[i]) ~= \(mergedRange)")
                // extending mergedRange to cover the current one
                mergedRange = RangeNode(start: min(mergedRange.start, sortedInput[i].start), end: max(mergedRange.end, sortedInput[i].end), count: 1)
//                Logger.rbtree.debug("mergedRange - \(mergedRange)")
            } else {
//                Logger.rbtree.debug("no overlap")
                // we encountered a non-mergeable range, hence saving the previous merge work
                contigs.append(mergedRange)
//                Logger.rbtree.debug("End merger - \(mergedRange)")
                // record the gap
                let gap = mergedRange.gap(with: sortedInput[i])
                gaps.append(gap)
//                Logger.rbtree.debug("appended gap - \(gap)")
                // reset the search
                mergedRange = sortedInput[i]
            }
            i += 1
        }
        // append last segment
        contigs.append(mergedRange)
        return (contigs, gaps)
    }
}
