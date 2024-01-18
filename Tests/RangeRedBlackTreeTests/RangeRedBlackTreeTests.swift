import XCTest
@testable import RangeRedBlackTree

final class RangeRedBlackTreeTests: XCTestCase {

    // Basic tests
    func testRootElementType() {
        let tree = RedBlackTree<RangeNode>()
        tree.insert(key: RangeNode(start: 1, end: 10, count: 1))
        tree.insert(key: RangeNode(start: 5, end: 15, count: 1))
        // Check if the root is correct
        XCTAssertNotNil(tree.root)
    }

    func testInsertNonOverlappingRanges() {
        let tree = RedBlackTree<RangeNode>()
        tree.insert(key: RangeNode(start: 1, end: 5, count: 1))
        tree.insert(key: RangeNode(start: 10, end: 15, count: 1))

        // Check if the root is correct
        XCTAssertNotNil(tree.root)

        // Check root range values
        XCTAssertEqual(tree.root.key?.start, 1)
        XCTAssertEqual(tree.root.key?.end, 5)

        // Check root color (should be black)
        XCTAssertEqual(tree.root.color, .black)

        // Check if the right child of the root is correct
        XCTAssertNotNil(tree.root.rightChild)
        XCTAssertEqual(tree.root.rightChild?.key?.start, 10)
        XCTAssertEqual(tree.root.rightChild?.key?.end, 15)

            // Check right child's color (should be red if the tree follows the standard Red-Black insertion)
        XCTAssertEqual(tree.root.rightChild?.color, .red)

        // Check if the left child of the root is nil (as per the inserted ranges)
        XCTAssertTrue(tree.root.leftChild?.isNullLeaf ?? false)
    }

    // adjacent ranges test
    func testMergeAdjacentRanges() {
        let tree = RedBlackTree<RangeNode>()
        tree.insert(key: RangeNode(start: 1, end: 5, count: 1))
        tree.insert(key: RangeNode(start: 5, end: 10, count: 1))

        // Check if the root is correct
        XCTAssertNotNil(tree.root)
        // Check that the root's range values reflect the merged range
        XCTAssertEqual(tree.root.key!.start, 1)
        XCTAssertEqual(tree.root.key!.end, 10)

        // Check the merged count (assuming counts are summed during merge)
        XCTAssertEqual(tree.root.key!.count, 1)

        // Check root color (should be black)
        XCTAssertEqual(tree.root.color, .black)

        // The tree should only have a root after merging, no children
        XCTAssertTrue(tree.root.leftChild?.isNullLeaf ?? false)
        XCTAssertTrue(tree.root.rightChild?.isNullLeaf ?? false)
    }


    func testSplitOverlappingRanges() {
        let tree = RedBlackTree<RangeNode>()
        tree.insert(key: RangeNode(start: 1, end: 10, count: 1))
        tree.insert(key: RangeNode(start: 5, end: 15, count: 1))

        // Check if the root is correct
        XCTAssertNotNil(tree.root)

        let root = tree.root

        print(tree)
        XCTAssertEqual(root.key?.start, 5)
        XCTAssertEqual(root.key?.end, 10)
        XCTAssertEqual(root.key?.count, 2)

        // Check if the tree correctly split the range and added new nodes
        // The number and position of these nodes will depend on your split logic
        XCTAssertNotNil(root.leftChild)
        XCTAssertEqual(root.leftChild?.key?.start, 1)
        XCTAssertEqual(root.leftChild?.key?.end, 5)
        XCTAssertEqual(root.leftChild?.key?.count, 1)

        XCTAssertNotNil(root.rightChild)
        XCTAssertEqual(root.rightChild?.key?.start, 10)
        XCTAssertEqual(root.rightChild?.key?.end, 15)
        XCTAssertEqual(root.rightChild?.key?.count, 1)
    }

    // Basic tests
    func testCount() {
        let tree = RedBlackTree<RangeNode>()
        tree.insert(key: RangeNode(start: 1, end: 10, count: 1))
        tree.insert(key: RangeNode(start: 15, end: 20, count: 1))
        // insert again
//        tree.insertRange(RangeNode(start: 1, end: 10, count: 1))
        tree.insert(key: RangeNode(start: 15, end: 20, count: 1))
        print(tree)
    }

    func testBuildContigs1() {
        let rs = [
            RangeNode(start: 1, end: 5, count: 1),
            RangeNode(start: 3, end: 7, count: 1),
            RangeNode(start: 7, end: 10, count: 1),
            RangeNode(start: 10, end: 15, count: 1),
            RangeNode(start: 20, end: 25, count: 1),
            RangeNode(start: 25, end: 30, count: 1),
            RangeNode(start: 40, end: 50, count: 1),
        ]

        let (contigs, gaps) = RangeNode.buildContigs(from: rs)
        print("------- contigs ----------")
        print(contigs)
        print("------- gaps ----------")
        print(gaps)
        XCTAssertTrue(contigs == [RangeNode(start: 1, end: 15, count: 1), RangeNode(start: 20, end: 30, count: 1), RangeNode(start: 40, end: 50, count: 1)])
        XCTAssertTrue(gaps == [RangeNode(start: 15, end: 20, count: 1), RangeNode(start: 30, end: 40, count: 1)])
    }


    func ztestPerformanceForLargeNumberOfRanges() {
        let tree = RedBlackTree<RangeNode>()

        measure {
            for i in 1...1_000 {
                let start = UInt32(i * 10)
                let end = UInt32(start + 32)
                tree.insert(key: RangeNode(start: start, end: end, count: 1))
            }
        }
    }
}
