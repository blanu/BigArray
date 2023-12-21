//
//  NestedArray.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/7/22.
//

import Foundation

public typealias NestedArrayLens = [Int]

public indirect enum NestedArray<Element>
{
    case element(Element)
    case array([NestedArray<Element>])
}

extension NestedArray
{
    public var element: Element?
    {
        switch self
        {
            case .element(let value):
                return value

            default:
                return nil
        }
    }

    public var array: [NestedArray<Element>]?
    {
        switch self
        {
            case .array(let value):
                return value

            default:
                return nil
        }
    }
}

extension NestedArray
{
    public func get(_ lens: NestedArrayLens) -> NestedArray?
    {
        switch self
        {
            case .element:
                guard lens.count == 0 else
                {
                    return nil
                }

                return self

            case .array(let array):
                if lens.count == 0
                {
                    return self
                }

                let rest = [Int](lens[1...])

                let index = lens[0]
                let next = array[index]
                return next.get(rest)
        }
    }
}

extension NestedArray: Sequence
{
    public var count: Int
    {
        switch self
        {
            case .element:
                return 1

            case .array(let array):
                return array.count
        }
    }

    public func makeIterator() -> NestedArrayIterator<Element>
    {
        return NestedArrayIterator(self)
    }
}

public struct NestedArrayIterator<Element>: IteratorProtocol
{
    let array: NestedArray<Element>
    var index: Int = 0

    public init(_ array: NestedArray<Element>)
    {
        self.array = array
    }

    mutating public func next() -> NestedArray<Element>?
    {
        guard self.index < self.array.count else
        {
            return nil
        }

        switch self.array
        {
            case .element:
                return self.array

            case .array(let subarray):
                let element = subarray[self.index]
                self.index = self.index + 1
                return element
        }
    }
}
