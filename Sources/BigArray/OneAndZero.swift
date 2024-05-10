//
//  OneAndZero.swift
//
//
//  Created by Dr. Brandon Wiley on 5/10/24.
//

import Foundation

import BigNumber

public protocol HasOne
{
    associatedtype OneType

    var one: OneType { get }
}

public protocol HasZero
{
    associatedtype ZeroType

    var zero: ZeroType { get }
}

extension BInt: HasOne
{
    public typealias OneType = Self

    public var one: Self
    {
        return BInt(1)
    }
}

extension BInt: HasZero
{
    public typealias ZeroType = Self

    public var zero: Self
    {
        return BInt(0)
    }
}
