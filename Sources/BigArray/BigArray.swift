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
        switch self.multiarray
        {
            case .one(let array):
                return BInt(array.count)

            case .two(let array):
                var result = BInt(0)
                for subarray in array
                {
                    result += BInt(subarray.count)
                }

                return result
        }
    }

    var multiarray: Multiarray<Element>

    public init()
    {
        self.multiarray = Multiarray<Element>.one([])
    }
}

extension BigArray: Sequence
{
    public typealias Iterator = MultiarrayIterator<Element>

    public func makeIterator() ->  MultiarrayIterator<Element>
    {
        return MultiarrayIterator<Element>(self.multiarray)
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
            switch self.multiarray
            {
                case .one(let array):
                    let index = position.asInt()!
                    return array[index]

                case .two(let array):
                    let index1 = (position / BInt(Int.max)).asInt()!
                    let index2 = (position % BInt(Int.max)).asInt()!
                    let subarray = array[index1]
                    return subarray[index2]
            }
        }

        set
        {
            switch self.multiarray
            {
                case .one(var array):
                    let index = position.asInt()!
                    array[index] = newValue
                    self.multiarray = .one(array)

                case .two(var array):
                    let index1 = (position / BInt(Int.max)).asInt()!
                    let index2 = (position % BInt(Int.max)).asInt()!
                    var subarray = array[index1]
                    subarray[index2] = newValue
                    array[index1] = subarray
                    self.multiarray = .two(array)
            }
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
        switch self.multiarray
        {
            case .one(var array):
                if subrange.upperBound <= BInt(Int.max)
                {
                    // The size of the array is growing, but not enough to require an upgrade to .two.

                    let intRange = subrange.lowerBound.asInt()!..<subrange.upperBound.asInt()!
                    array.replaceSubrange(intRange, with: newElements)
                    self.multiarray = .one(array)
                }
                else
                {
                    // This size of the array is growing enough to require an upgrde to .two.
                    return // FIXME
                }

            default:
                return // FIXME
        }
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
    public func map(_ transform: (Element) throws -> Element) rethrows -> Self
    {
        var results: BigArray = BigArray()

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
