//
//  Multiarray.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/20/22.
//

import Foundation

public enum Multiarray<T>: Equatable, Hashable, Codable where T: Equatable, T: Hashable, T: Codable
{
    case one([T])
    case two([[T]])
}

extension Multiarray: Sequence
{
    public typealias Element = T
    public typealias Iterator = MultiarrayIterator<T>

    public func makeIterator() ->  MultiarrayIterator<T>
    {
        return MultiarrayIterator<T>(self)
    }
}

public struct MultiarrayIterator<T>: IteratorProtocol where T: Equatable, T: Hashable, T: Codable
{
    public typealias Element = T

    let multiarray: Multiarray<T>
    var indices: [Int]

    public init(_ multiarray: Multiarray<T>)
    {
        self.multiarray = multiarray

        switch multiarray
        {
            case .one:
                self.indices = [0]

            case .two:
                self.indices = [0, 0]
        }
    }

    mutating public func next() -> Element?
    {
        switch self.multiarray
        {
            case .one(let array):
                let index = self.indices[0]

                guard (index >= 0) && (index < array.count) else
                {
                    return nil
                }

                let result = array[index]
                self.indices[0] = index + 1
                return result

            case .two(let array):
                let index0 = self.indices[0]
                let index1 = self.indices[1]

                guard (index0 >= 0) && (index0 < array.count) else
                {
                    return nil
                }

                let subarray = array[index0]

                guard (index1 >= 0) && (index1 < subarray.count) else
                {
                    return nil
                }

                let result = subarray[index1]
                if index1 + 1 == subarray.count
                {
                    self.indices[1] = 0
                    self.indices[0] = index0 + 1
                }
                else
                {
                    self.indices[1] = index1 + 1
                }

                return result
        }
    }
}
