# RangeRedBlackTree
A Swift implementation of a red-black tree for an range or interval.

This work is inspired by and based on [https://github.com/kodecocodes/swift-algorithm-club/tree/master/Red-Black%20Tree]. It is exnteded for a use case when the tree node is a half-open range that has a count attribute representing the range coverage.  

The logic implemented by the tree is as follows:  
- a RangeNode has a starting position, an ending position (not included in the range), and a `count` attribute.
- if an input range's sstart and and exactly match one already in the tree, we sum the count attribute of the one in the tree and the input one.
- if an input range is adjacent to to a range in the tree and their counts are the same, we extend the existing range to cover both the existing one and the input one.
if an input range partially overalaps an existing range, we split the existing and the input ranges so that each subrange with unique count value (or their sum) gets to be a new range.

The rest of the tree functionality remans the same as in a classic red-black tree.


