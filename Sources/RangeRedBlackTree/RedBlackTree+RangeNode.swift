//
//  RedBlackTree+RangeNode.swift
//  RangeNode extensions for RedBlackTree
//
//  Created by Ilia Sazonov on 11/26/23.
//

import Foundation
import OSLog

extension RedBlackTree where T == RangeNode {
    public func insert(key: RangeNode) {
        if root.isNullLeaf {
            root = RBNode(key: key)
        } else {
            insert(input: RBNode(key: key), parentNode: root)
        }
    }

    private func insert(input: RBNode, parentNode: RBNode) {
        guard let inputKey = input.key else { return }
        var currentNode = parentNode
        while true {
            guard let nodeKey = currentNode.key else { return }
            // if node matched precisely, incrementing the count and exiting
            if inputKey == nodeKey {
                currentNode.key?.count += inputKey.count
                return
            }
            if inputKey < nodeKey {
//                Logger.rbtree.debug("\(inputKey) < \(nodeKey)")
                // if null then add as a left child
                guard let child = currentNode.leftChild else {
                    addAsLeftChild(child: input, parent: currentNode)
                    size += 1
                    return
                }
                if child.isNullLeaf {
                    addAsLeftChild(child: input, parent: currentNode)
                    size += 1
                    return
                }
                // otherwise go down the tree
                currentNode = child
            } else if inputKey > nodeKey {
                // if null then add as a right child
//                Logger.rbtree.debug("\(inputKey) > \(nodeKey)")
                guard let child = currentNode.rightChild else {
                    addAsRightChild(child: input, parent: currentNode)
                    size += 1
                    return
                }
                if child.isNullLeaf {
                    addAsRightChild(child: input, parent: currentNode)
                    size += 1
                    return
                }
                // otherwise go down the tree
                currentNode = child
            } else if inputKey ~= nodeKey {
                // overlapping or adjacent ranges
//                Logger.rbtree.debug("\(inputKey) ~= \(nodeKey)")
                if input.shouldMergeWith(node: currentNode) {
                    if currentNode.isActualLeaf  {
                        // we can just update the values
                        currentNode.key!.start = min(inputKey.start, nodeKey.start)
                        currentNode.key!.end = max(inputKey.end, nodeKey.end)
                        return
                    } else {
                        // now that we know that the currenNode is not a leaf node
                        let parent = currentNode.parent ?? root
                        delete(node: currentNode)
                        let newNode = RBNode(key: RangeNode(start: min(inputKey.start, nodeKey.start), end: max(inputKey.end, nodeKey.end), count: inputKey.count))
                        insert(input: newNode, parentNode: parent)
                        return
                    }
                } else if input.shouldSplitWith(node: currentNode) {
                    // overlapping
//                    Logger.rbtree.debug("\(inputKey) should split with \(nodeKey)")
                    // splitWith returns RangeNode objects
                    guard let splitNodes = input.splitWith(node: currentNode) else { return }
//                    Logger.rbtree.debug("splitNodes: (\(splitNodes.0?.description ?? "nil"), \(splitNodes.1), \(splitNodes.2?.description ?? "nil")")
                    // we can just use this node as the first split and insert the rest of the splits
                    currentNode.key = splitNodes.1
                    // and then we insert the left and right split nodes
                    if let leftSplit = splitNodes.0 {
//                        Logger.rbtree.debug("inserting leftSplit under \(currentNode)")
                        insert(input: RBNode(key: leftSplit), parentNode: currentNode)
                    }
                    if let rightSplit = splitNodes.2 {
//                        Logger.rbtree.debug("inserting right under \(currentNode)")
                        insert(input: RBNode(key: rightSplit), parentNode: currentNode)
                    }
                } else {
                    // adjacent with different counts
                    fatalError("adjacent with unequal counts")
                }
                return
            } else {
                fatalError("weird nodeKey and inputKey condition!\n inputKey: \(inputKey),\n nodeKey: \(nodeKey)")
            }
        }
    }
}

