//Copyright (c) 2016 Matthijs Hollemans and contributors
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

// Modified by Ilia Sazonov for the purpose of RangeRedBlackTree implementation.

import Foundation

public enum RBTreeColor {
    case red
    case black
}

// MARK: - RBNode

public class RBTreeNode<T: Comparable>: Equatable {
    public typealias RBNode = RBTreeNode<T>

    var color: RBTreeColor = .black
    var key: T?
    var leftChild: RBNode?
    var rightChild: RBNode?
    weak var parent: RBNode?

    public init(key: T?, leftChild: RBNode?, rightChild: RBNode?, parent: RBNode?) {
        self.key = key
        self.leftChild = leftChild
        self.rightChild = rightChild
        self.parent = parent

        self.leftChild?.parent = self
        self.rightChild?.parent = self
    }

    public convenience init(key: T?) {
        self.init(key: key, leftChild: RBNode(), rightChild: RBNode(), parent: RBNode())
    }

    // For initialising the nullLeaf
    public convenience init() {
        self.init(key: nil, leftChild: nil, rightChild: nil, parent: nil)
        self.color = .black
    }

    var isRoot: Bool {
        return parent == nil
    }

    var isLeaf: Bool {
        return rightChild == nil && leftChild == nil
    }

    var isNullLeaf: Bool {
        return key == nil && isLeaf && color == .black
    }

    var isLeftChild: Bool {
        return parent?.leftChild === self
    }

    var isRightChild: Bool {
        return parent?.rightChild === self
    }

    var grandparent: RBNode? {
        return parent?.parent
    }

    var sibling: RBNode? {
        if isLeftChild {
            return parent?.rightChild
        } else {
            return parent?.leftChild
        }
    }

    var uncle: RBNode? {
        return parent?.sibling
    }
}

// MARK: - Equatable protocol

extension RBTreeNode {
    static public func == (lhs: RBTreeNode<T>, rhs: RBTreeNode<T>) -> Bool {
        return lhs.key == rhs.key
    }
}

// MARK: - Finding a nodes successor

extension RBTreeNode {
    /*
     * Returns the inorder successor node of a node
     * The successor is a node with the next larger key value of the current node
     */
    public func getSuccessor() -> RBNode? {
        // If node has right child: successor min of this right tree
        if let rightChild = self.rightChild {
            if !rightChild.isNullLeaf {
                return rightChild.minimum()
            }
        }
        // Else go upward until node left child
        var currentNode = self
        var parent = currentNode.parent
        while currentNode.isRightChild {
            if let parent = parent {
                currentNode = parent
            }
            parent = currentNode.parent
        }
        return parent
    }
}

// MARK: - Searching

extension RBTreeNode {
    /*
     * Returns the node with the minimum key of the current subtree
     */
    public func minimum() -> RBNode? {
        if let leftChild = leftChild {
            if !leftChild.isNullLeaf {
                return leftChild.minimum()
            }
            return self
        }
        return self
    }

    /*
     * Returns the node with the maximum key of the current subtree
     */
    public func maximum() -> RBNode? {
        if let rightChild = rightChild {
            if !rightChild.isNullLeaf {
                return rightChild.maximum()
            }
            return self
        }
        return self
    }
}

// MARK: - Debugging

extension RBTreeNode: CustomDebugStringConvertible {
    public var debugDescription: String {
        var s = ""
        if isNullLeaf {
            s = "nullLeaf"
        } else {
            if let key = key {
                s = "key: \(key)"
            } else {
                s = "key: nil"
            }
            if let parent = parent {
                s += ", parent: \(String(describing: parent.key))"
            }
            if let left = leftChild {
                s += ", left = [" + left.debugDescription + "]"
            }
            if let right = rightChild {
                s += ", right = [" + right.debugDescription + "]"
            }
            s += ", color = \(color)"
        }
        return s
    }
}

extension RBTreeNode: CustomStringConvertible {
    public var description: String {
        var s = ""
        if isNullLeaf {
            s += "nullLeaf"
        } else {
            if let left = leftChild {
                s += "(\(left.description)) <- "
            }
            if let key = key {
                s += "\(key)"
            } else {
                s += "nil"
            }
            s += ", \(color)"
            if let right = rightChild {
                s += " -> (\(right.description))"
            }
        }
        return s
    }
}

