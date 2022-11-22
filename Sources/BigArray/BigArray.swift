//
//  BigArray.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/20/22.
//

import Foundation

import BigNumber

public struct BigArray: Equatable, Hashable, Codable
{
    public var startIndex: BigNum = .int(BInt(0))
    public var endIndex: BigNum
    {
        switch self.multiarray
        {
            case .one(let array):
                return .int(BInt(array.count))

            case .two(let array):
                var result = BInt(0)
                for subarray in array
                {
                    result += BInt(subarray.count)
                }

                return .int(result)
        }
    }

    var multiarray: Multiarray<BigNum>

    public init()
    {
        self.multiarray = Multiarray<BigNum>.one([])
    }
}

extension BigArray: Sequence
{
    public typealias Element = BigNum
    public typealias Iterator = MultiarrayIterator<Element>

    public func makeIterator() ->  MultiarrayIterator<Element>
    {
        return MultiarrayIterator<Element>(self.multiarray)
    }
}

extension BigArray: Collection
{
    public typealias Index = BigNum

    public func index(after i: BigNum) -> BigNum
    {
        return .int(i.int! + 1)
    }

    public subscript(position: Index) -> Element
    {
        get
        {
            switch self.multiarray
            {
                case .one(let array):
                    let index = position.int!.asInt()!
                    return array[index]

                case .two(let array):
                    let index1 = (position.int! / BInt(Int.max)).asInt()!
                    let index2 = (position.int! % BInt(Int.max)).asInt()!
                    let subarray = array[index1]
                    return subarray[index2]
            }
        }

        set
        {
            switch self.multiarray
            {
                case .one(var array):
                    let index = position.int!.asInt()!
                    array[index] = newValue
                    self.multiarray = .one(array)

                case .two(var array):
                    let index1 = (position.int! / BInt(Int.max)).asInt()!
                    let index2 = (position.int! % BInt(Int.max)).asInt()!
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
    public func index(before i: BigNum) -> BigNum
    {
        return .int(i.int! - 1)
    }
}

extension BigArray: MutableCollection
{
}

extension BigArray: RandomAccessCollection
{
    public func index(_ i: BigNum, offsetBy distance: Int) -> BigNum
    {
        return .int(i.int! + BInt(distance))
    }

    public func distance(from start: BigNum, to end: BigNum) -> Int
    {
        return (end.int! - start.int!).asInt()!
    }
}

extension BigArray: RangeReplaceableCollection
{
    mutating public func replaceSubrange<C>(_ subrange: Range<BigNum>, with newElements: C) where C : Collection, BigNum == C.Element
    {
        switch self.multiarray
        {
            case .one(var array):
                if subrange.upperBound <= BigNum.int(BInt(Int.max))
                {
                    // The size of the array is growing, but not enough to require an upgrade to .two.

                    let intRange = subrange.lowerBound.int!.asInt()!..<subrange.upperBound.int!.asInt()!
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
    public init(arrayLiteral elements: BigNum...)
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

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
            let result = try transform(element)
            results.append(result)
        }

        return results
    }

    public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
    {
        var results: [T] = []

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
            let result = try transform(element)
            results.append(result)
        }

        return results
    }

    public func flatMap(_ transform: (Element) throws -> Self) rethrows -> Self
    {
        var results: BigArray = BigArray()

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
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

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
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

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
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

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
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

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
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

        for index in self.startIndex.int!..<self.endIndex.int!
        {
            let element = self[BigNum.int(index)]
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
