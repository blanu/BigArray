//
//  BigArray.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/20/22.
//

import Foundation

import BigNumber

public struct BigArray<T>: Equatable, Hashable, Codable where T: Numeric, T: Equatable, T: Comparable, T: Hashable, T: Codable
{
    public typealias Element = T

    public var startIndex: BInt = BInt(0)
    public var endIndex: BInt
    {
        return BInt(self.array.count)
    }

    public var shape: BigArray<BInt>
    {
        if let internalShape = internalShape
        {
            var array = BigArray<BInt>()
            for int in internalShape
            {
                array.append(BInt(int))
            }

            return array
        }
        else
        {
            return BigArray<BInt>()
        }
    }

    public var tag: BigArray<BInt>
    {
        if let internalTag = internalTag
        {
            return BigArray<BInt>(array: internalTag)
        }
        else
        {
            return BigArray<BInt>()
        }
    }

    public var effect: BigArray<BInt>
    {
        if let internalEffect = internalEffect
        {
            return BigArray<BInt>(array: internalEffect)
        }
        else
        {
            return BigArray<BInt>()
        }
    }

    public var array: [Element]
    var internalShape: [Int]?
    var internalTag: [BInt]?
    var internalEffect: [BInt]?

    public init()
    {
        self.init(array: nil)
    }

    public init(array: [Element]? = nil, shape: [Int]? = nil, tag: [BInt]? = nil, effect: [BInt]? = nil)
    {
        if let array = array
        {
            self.array = array
        }
        else
        {
            self.array = []
        }

        if let shape = shape
        {
            self.internalShape = shape
        }

        if let tag = tag
        {
            self.internalTag = tag
        }

        if let effect = effect
        {
            self.internalEffect = effect
        }
    }
}

extension BigArray: Sequence
{
    public typealias Iterator = IndexingIterator<[Element]>

    public func makeIterator() -> Iterator
    {
        return self.array.makeIterator()
    }
}

extension BigArray: Collection
{
    public typealias Index = BInt

    public func index(after i: Index) -> Index
    {
        return i + 1
    }

    public subscript(position: Index) -> Element
    {
        get
        {
            let index = position.asInt()!
            return self.array[index]
        }

        set
        {
            let index = position.asInt()!
            self.array[index] = newValue
        }
    }
}

extension BigArray: BidirectionalCollection
{
    public func index(before i: Index) -> Index
    {
        return i - BInt(1)
    }
}

extension BigArray: MutableCollection
{
}

extension BigArray: RandomAccessCollection
{
    public func index(_ i: Index, offsetBy distance: Int) -> Index
    {
        return i + BInt(distance)
    }

    public func distance(from start: Index, to end: Index) -> Int
    {
        return (end - start).asInt()!
    }
}

extension BigArray: RangeReplaceableCollection
{
    mutating public func replaceSubrange<C>(_ subrange: Range<Self.Index>, with newElements: C) where C : Collection, Self.Element == C.Element
    {
        let intRange = subrange.lowerBound.asInt()!..<subrange.upperBound.asInt()!
        self.array.replaceSubrange(intRange, with: newElements)
    }
}

extension BigArray: ExpressibleByArrayLiteral
{
    public init(arrayLiteral elements: Element...)
    {
        self.init()

        for element in elements
        {
            self.append(element)
        }
    }
}

extension BigArray
{
    public func map<T>(_ transform: (Element) throws -> T) rethrows -> BigArray<T> where T: Numeric
    {
        var results: BigArray<T> = BigArray<T>()

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            let result = try transform(element)
            results.append(result)
        }

        return results
    }

    public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
    {
        var results: [T] = []

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            let result = try transform(element)
            results.append(result)
        }

        return results
    }

    public func flatMap(_ transform: (Element) throws -> Self) rethrows -> Self
    {
        var results: BigArray = BigArray()

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            let segment = try transform(element)
            for result in segment
            {
                results.append(result)
            }
        }

        return results
    }

    public func flatMap<SegmentOfResult>(_ transform: (Self.Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence
    {
        var results: [SegmentOfResult.Element] = []

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            let segment = try transform(element)
            for result in segment
            {
                results.append(result)
            }
        }

        return results
    }

    public func flatMap<T>(_ transform: (Self.Element) throws -> BigArray<T>) rethrows -> BigArray<T> where T: AdditiveArithmetic
    {
        var results: BigArray<T> = BigArray<T>()

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            let segment = try transform(element)
            for result in segment
            {
                results.append(result)
            }
        }

        return results
    }

    func flatMap(_ transform: (Element) throws -> Element?) rethrows -> BigArray
    {
        var results: BigArray = BigArray()

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            if let result = try transform(element)
            {
                results.append(result)
            }
        }

        return results
    }

    func flatMap<ElementOfResult>(_ transform: (Self.Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
    {
        var results: [ElementOfResult] = []

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            if let result = try transform(element)
            {
                results.append(result)
            }
        }

        return results
    }

    public func compactMap(_ transform: (Element) throws -> Element?) rethrows -> BigArray
    {
        var results: BigArray = BigArray()

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            if let result = try transform(element)
            {
                results.append(result)
            }
        }

        return results
    }

    public func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> [T]
    {
        var results: [T] = []

        for index in self.startIndex..<self.endIndex
        {
            let element = self[index]
            if let result = try transform(element)
            {
                results.append(result)
            }
        }

        return results
    }

    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Self.Element) throws -> Result) rethrows -> Result
    {
        var current: Result = initialResult
        for element in self
        {
            current = try nextPartialResult(current, element)
        }

        return current
    }

    func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Self.Element) throws -> ()) rethrows -> Result
    {
        var current: Result = initialResult
        for element in self
        {
            try updateAccumulatingResult(&current, element)
        }

        return current
    }
}

extension BigArray
{
    public func sorted(by f: (Element, Element) -> Bool) -> Self
    {
        return BigArray(self.array.sorted(by: f))
    }
}
