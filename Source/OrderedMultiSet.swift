//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

public class OrderedMultiSet<Element : Comparable> : Probability<Element>, CollectionType, Comparable, Equatable, Printable {
	public typealias Generator = GeneratorOf<Element>
	public typealias OrderedIndex = RedBlackTree<Element, Int>
	
	/**
		:name:	tree
		:description:	Internal storage of elements.
		:returns:	RedBlackTree<Element, Element>
	*/
	internal var tree: RedBlackTree<Element, Element>

	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the OrderedMultiSet in a readable format.
		:returns:	String
	*/
	public var description: String {
		var output: String = "["
		for var i: Int = 0, l = count - 1; i <= l; ++i {
			output += "\(self[i])"
			if i != l {
				output += ", "
			}
		}
		return output + "]"
	}

	/**
		:name:	first
		:description:	Get the first node value in the tree, this is
		the first node based on the order of keys where
		k1 <= k2 <= K3 ... <= Kn
		:returns:	Element?
	*/
	public var first: Element? {
		return tree.first?.value
	}

	/**
		:name:	last
		:description:	Get the last node value in the tree, this is
		the last node based on the order of keys where
		k1 <= k2 <= K3 ... <= Kn
		:returns:	Element?
	*/
	public var last: Element? {
		return tree.last?.value
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the RedBlackTree is empty.
		:returns:	Bool
	*/
	public var isEmpty: Bool {
		return 0 == count
	}

	/**
		:name:	startIndex
		:description:	Conforms to the CollectionType Protocol.
		:returns:	Int
	*/
	public var startIndex: Int {
		return 0
	}

	/**
		:name:	endIndex
		:description:	Conforms to the CollectionType Protocol.
		:returns:	Int
	*/
	public var endIndex: Int {
		return count
	}

	/**
		:name:	init
		:description:	Constructor
	*/
	public override init() {
		tree = RedBlackTree<Element, Element>(uniqueKeys: false)
	}

	/**
		:name:	init
		:description:	Constructor
	*/
	public convenience init(elements: Element...) {
		self.init(elements: elements)
	}

	/**
		:name:	init
		:description:	Constructor
	*/
	public convenience init(elements: Array<Element>) {
		self.init()
		insert(elements)
	}

	/**
		:name:	generate
		:description:	Conforms to the SequenceType Protocol. Returns
		the next value in the sequence of nodes using
		index values [0...n-1].
		:returns:	OrderedMultiSet.Generator
	*/
	public func generate() -> OrderedMultiSet.Generator {
		var index = startIndex
		return GeneratorOf {
			if index < self.endIndex {
				return self[index++]
			}
			return nil
		}
	}

	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		Items are kept in order, so when iterating
		through the items, they are returned in their
		ordered form.
		:returns:	Element
	*/
	public subscript(index: Int) -> Element {
		return tree[index].key
	}

	/**
		:name:	indexOf
		:description:	Returns the Index of a given member, or nil if the member is not present in the set.
		:returns:	OrderedMultiSet.OrderedIndex
	*/
	public func indexOf(elements: Element...) -> OrderedMultiSet.OrderedIndex {
		return indexOf(elements)
	}
	
	/**
		:name:	indexOf
		:description:	Returns the Index of a given member, or nil if the member is not present in the set.
		:returns:	OrderedMultiSet.OrderedIndex
	*/
	public func indexOf(elements: Array<Element>) -> OrderedMultiSet.OrderedIndex {
		return tree.indexOf(elements)
	}
	
	/**
		:name:	contains
		:description:	A boolean check if values exists
		in the set.
		:returns:	Bool
	*/
	public func contains(elements: Element...) -> Bool {
		return contains(elements)
	}
	
	/**
		:name:	contains
		:description:	A boolean check if an array of values exist
		in the set.
		:returns:	Bool
	*/
	public func contains(elements: Array<Element>) -> Bool {
		if 0 == elements.count {
			return false
		}
		for x in elements {
			if nil == tree.findValueForKey(x) {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
		:returns:	Int
	*/
	public override func countOf(elements: Element...) -> Int {
		return tree.countOf(elements)
	}

	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
		:returns:	Int
	*/
	public override func countOf(elements: Array<Element>) -> Int {
		return tree.countOf(elements)
	}

	/**
		:name:	insert
		:description:	Inserts new elements into the OrderedMultiSet.
	*/
	public func insert(elements: Element...) {
		insert(elements)
	}

	/**
		:name:	insert
		:description:	Inserts new elements into the OrderedMultiSet.
	*/
	public func insert(elements: Array<Element>) {
		for x in elements {
			tree.insert(x, value: x)
		}
		count = tree.count
	}

	/**
		:name:	remove
		:description:	Removes elements from the OrderedMultiSet.
		:returns:	OrderedMultiSet<Element>
	*/
	public func remove(elements: Element...) -> OrderedMultiSet<Element> {
		return remove(elements)
	}

	/**
		:name:	remove
		:description:	Removes elements from the OrderedMultiSet.
		:returns:	OrderedMultiSet<Element>
	*/
	public func remove(elements: Array<Element>) -> OrderedMultiSet<Element> {
		let s: OrderedMultiSet<Element> = OrderedMultiSet<Element>()
		for x in elements {
			let n: Int = tree.countOf(x)
			if 0 < n {
				tree.removeValueForKey(x)
				for i in 0..<n {
					s.insert(x)
				}
			}
		}
		count = tree.count
		return s
	}

	/**
		:name:	removeAll
		:description:	Remove all nodes from the tree.
	*/
	public func removeAll() {
		tree.removeAll()
		count = tree.count
	}

	/**
		:name:	intersect
		:description:	Return a new set with elements common to this set and a finite sequence of Sets.
		:returns:	OrderedMultiSet<Element>
	*/
	public func intersect(sets: OrderedMultiSet<Element>...) -> OrderedMultiSet<Element> {
		return intersect(sets)
	}

	/**
		:name:	intersect
		:description:	Return a new set with elements common to this set and a finite sequence of Sets.
		:returns:	OrderedMultiSet<Element>
	*/
	public func intersect(sets: Array<OrderedMultiSet<Element>>) -> OrderedMultiSet<Element> {
		let s: OrderedMultiSet<Element> = OrderedMultiSet<Element>()
		for var i: Int = tree.count - 1; 0 <= i; --i {
			let x: Element = tree[i].key
			var toInsert: Bool = true
			for u in sets {
				if nil == u.tree.findValueForKey(x) {
					toInsert = false
					break
				}
			}
			if toInsert {
				let q: Int = tree.countOf(x)
				var n: Int = q
				for u in sets {
					let m: Int = u.tree.countOf(x)
					if m < n {
						n = m
					}
				}
				i -= q - 1
				while 0 < n-- {
					s.insert(x)
				}
			}
		}
		return s
	}

	/**
		:name:	intersectInPlace
		:description:	Insert elements of a finite sequence of Sets.
	*/
	public func intersectInPlace(sets: OrderedMultiSet<Element>...) {
		intersectInPlace(sets)
	}

	/**
		:name:	intersectInPlace
		:description:	Remove any elements of this set that aren't also in a finite sequence of Sets.
	*/
	public func intersectInPlace(sets: Array<OrderedMultiSet<Element>>) {
		for var i: Int = tree.count - 1; 0 <= i; --i {
			let x: Element = tree[i].key
			var toRemove: Bool = false
			for u in sets {
				if nil == u.tree.findValueForKey(x) {
					toRemove = true
					break
				}
			}
			var q: Int = tree.countOf(x)
			if toRemove {
				tree.removeValueForKey(x)
				i -= --q
			} else {
				var n: Int = q
				for u in sets {
					let m: Int = u.tree.countOf(x)
					if m < n {
						n = m
					}
				}
				if q != n {
					n = q - n
					i -= q - n - 1
					while 0 < n-- {
						tree.removeInstanceOfValueForKey(x)
					}
				}
			}
		}
		count = tree.count
	}

	/**
		:name:	union
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
		:returns:	OrderedMultiSet<Element>
	*/
	public func union(sets: OrderedMultiSet<Element>...) -> OrderedMultiSet<Element> {
		return union(sets)
	}

	/**
		:name:	union
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
		:returns:	OrderedMultiSet<Element>
	*/
	public func union(sets: Array<OrderedMultiSet<Element>>) -> OrderedMultiSet<Element> {
		let s: OrderedMultiSet<Element> = OrderedMultiSet<Element>()
		for u in sets {
			for x in u {
				s.insert(x)
			}
		}
		for x in self {
			s.insert(x)
		}
		return s
	}

	/**
		:name:	unionInPlace
		:description:	Return a new Set with items in both this set and a finite sequence of Sets.
	*/
	public func unionInPlace(sets: OrderedMultiSet<Element>...) {
		unionInPlace(sets)
	}

	/**
		:name:	unionInPlace
		:description:	Insert elements of a finite sequence of Sets.
	*/
	public func unionInPlace(sets: Array<OrderedMultiSet<Element>>) {
		for u in sets {
			for x in u {
				insert(x)
			}
		}
	}

	/**
		:name:	subtract
		:description:	Return a new set with elements in this set that do not occur in a finite sequence of Sets.
		:returns:	OrderedMultiSet<Element>
	*/
	public func subtract(sets: OrderedMultiSet<Element>...) -> OrderedMultiSet<Element> {
		return subtract(sets)
	}
	
	/**
		:name:	subtract
		:description:	Return a new set with elements in this set that do not occur in a finite sequence of Sets.
		:returns:	OrderedMultiSet<Element>
	*/
	public func subtract(sets: Array<OrderedMultiSet<Element>>) -> OrderedMultiSet<Element> {
		let s: OrderedMultiSet<Element> = OrderedMultiSet<Element>()
		for var i: Int = tree.count - 1; 0 <= i; --i {
			let x: Element = tree[i].key
			for u in sets {
				if nil != u.tree.findValueForKey(x) {
					var n: Int = tree.countOf(x)
					if 1 < n {
						i -= (n - 1)
					}
					while 0 < n-- {
						s.insert(x)
					}
					break
				}
			}
		}
		return s
	}
	
	/**
		:name:	subtractInPlace
		:description:	Remove all elements in the set that occur in a finite sequence of Sets.
	*/
	public func subtractInPlace(sets: OrderedMultiSet<Element>...) {
		subtractInPlace(sets)
	}
	
	/**
		:name:	subtractInPlace
		:description:	Remove all elements in the set that occur in a finite sequence of Sets.
	*/
	public func subtractInPlace(sets: Array<OrderedMultiSet<Element>>) {
		for var i: Int = tree.count - 1; 0 <= i; --i {
			let x: Element = tree[i].key
			for u in sets {
				if nil != u.tree.findValueForKey(x) {
					let n: Int = tree.countOf(x)
					tree.removeValueForKey(x)
					i -= n - 1
					break
				}
			}
		}
		count = tree.count
	}
	
	/**
		:name:	exclusiveOr
		:description:	Return a new set with elements that are either in the set or a finite sequence but do not occur in both.
		:returns:	OrderedMultiSet<Element>
	*/
	public func exclusiveOr(sets: OrderedMultiSet<Element>...) -> OrderedMultiSet<Element> {
		return exclusiveOr(sets)
	}
	
	/**
		:name:	exclusiveOr
		:description:	Return a new set with elements that are either in the set or a finite sequence but do not occur in both.
		:returns:	OrderedMultiSet<Element>
	*/
	public func exclusiveOr(var sets: Array<OrderedMultiSet<Element>>) -> OrderedMultiSet<Element> {
		let s: OrderedMultiSet<Element> = OrderedMultiSet<Element>()
		sets.append(self)
		for var i: Int = sets.count - 1; 0 <= i; --i {
			let t: RedBlackTree<Element, Element> = sets[i].tree
			for var k: Int = t.count - 1; 0 <= k; --k {
				let x: Element = t[k].key
				var toInsert: Bool = true
				for var j: Int = sets.count - 1; 0 <= j; --j {
					if i != j {
						if nil != sets[j].tree.findValueForKey(x) {
							toInsert = false
							break
						}
					}
				}
				if toInsert {
					var n: Int = t.countOf(x)
					k -= n - 1
					while 0 < n-- {
						s.insert(x)
					}
				}
			}
		}
		return s
	}
	
	/**
		:name:	exclusiveOrInPlace
		:description:	For each element of a finite sequence, remove it from the set if it is a
		common element, otherwise add it to the set. Repeated elements of the sequence will be
		ignored.
	*/
	public func exclusiveOrInPlace(sets: OrderedMultiSet<Element>...) {
		exclusiveOrInPlace(sets)
	}
	
	/**
		:name:	exclusiveOrInPlace
		:description:	For each element of a finite sequence, remove it from the set if it is a
		common element, otherwise add it to the set. Repeated elements of the sequence will be
		ignored.
	*/
	public func exclusiveOrInPlace(sets: Array<OrderedMultiSet<Element>>) {
		let n: Int = sets.count - 1
		for var i: Int = n; 0 <= i; --i {
			let t: RedBlackTree<Element, Element> = sets[i].tree
			for var k: Int = t.count - 1; 0 <= k; --k {
				let x: Element = t[k].key
				var toInsert: Bool = true
				for var j: Int = n; 0 <= j; --j {
					if i != j {
						if nil != sets[j].tree.findValueForKey(x) {
							toInsert = false
							break
						}
					}
				}
				if toInsert && nil == tree.findValueForKey(x) {
					var n: Int = t.countOf(x)
					k -= n - 1
					while 0 < n-- {
						insert(x)
					}
				} else {
					tree.removeValueForKey(x)
				}
			}
		}
		count = tree.count
	}
	
	/**
		:name:	isDisjointWith
		:description:	Returns true if no elements in the set are in a finite sequence of Sets.
		:returns:	Bool
	*/
	public func isDisjointWith(sets: OrderedMultiSet<Element>...) -> Bool {
		return isDisjointWith(sets)
	}
	
	/**
		:name:	isDisjointWith
		:description:	Returns true if no elements in the set are in a finite sequence of Sets.
		:returns:	Bool
	*/
	public func isDisjointWith(var sets: Array<OrderedMultiSet<Element>>) -> Bool {
		for var i: Int = tree.count - 1; 0 <= i; --i {
			let x: Element = tree[i].key
			for u in sets {
				if nil != u.tree.findValueForKey(x) {
					return false
				}
			}
			let n: Int = tree.countOf(x)
			if 1 < n {
				i -= n - 1
			}
		}
		return true
	}
	
	
	/**
		:name:	isSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set.
		:returns:	Bool
	*/
	public func isSubsetOf(set: OrderedMultiSet<Element>) -> Bool {
		if count > set.count {
			return false
		}
		for (x, _) in tree {
			if nil == set.tree.findValueForKey(x) {
				return false
			}
		}
		return true
	}

	/**
		:name:	isStrictSubsetOf
		:description:	Returns true if the set is a subset of a finite sequence as a Set but not equal.
		:returns:	Bool
	*/
	public func isStrictSubsetOf(set: OrderedMultiSet<Element>) -> Bool {
		return count < set.count && isSubsetOf(set)
	}
	
	/**
		:name:	isSupersetOf
		:description:	Returns true if the set is a superset of a finite sequence as a Set.
		:returns:	Bool
	*/
	public func isSupersetOf(set: OrderedMultiSet<Element>) -> Bool {
		if count < set.count {
			return false
		}
		for (x, _) in set.tree {
			if nil == tree.findValueForKey(x) {
				return false
			}
		}
		return true
	}
	
	/**
		:name:	isStrictSupersetOf
		:description:	Returns true if the set is a superset of a finite sequence as a Set but not equal.
		:returns:	Bool
	*/
	public func isStrictSupersetOf(set: OrderedMultiSet<Element>) -> Bool {
		return count > set.count && isSupersetOf(set)
	}
}

public func ==<Element: Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> Bool {
	if lhs.count != rhs.count {
		return false
	}
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		if lhs.tree[i].key != rhs.tree[i].key {
			return false
		}
	}
	return true
}

public func +<Element : Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> OrderedMultiSet<Element> {
	return lhs.union(rhs)
}

public func -<Element : Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> OrderedMultiSet<Element> {
	return lhs.subtract(rhs)
}

public func <=<Element : Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> Bool {
	return lhs.isSubsetOf(rhs)
}

public func >=<Element : Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> Bool {
	return lhs.isSupersetOf(rhs)
}

public func ><Element : Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> Bool {
	return lhs.isStrictSupersetOf(rhs)
}

public func <<Element : Comparable>(lhs: OrderedMultiSet<Element>, rhs: OrderedMultiSet<Element>) -> Bool {
	return lhs.isStrictSubsetOf(rhs)
}
