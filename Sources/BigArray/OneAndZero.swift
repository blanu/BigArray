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

    static var one: OneType { get }
}

public protocol HasZero
{
    associatedtype ZeroType

    static var zero: ZeroType { get }
}

extension BInt: HasOne
{
    public typealias OneType = Self

    static public var one: Self
    {
        return BInt(1)
    }
}

extension BInt: HasZero
{
    public typealias ZeroType = Self

    static public var zero: Self
    {
        return BInt(0)
    }
}

extension BDouble: HasZero
{
    public typealias ZeroType = Self

    static public var zero: Self
    {
        return BDouble(0)
    }
}

extension BDouble: HasOne
{
    public typealias OneType = Self

    static public var one: Self
    {
        return BDouble(1)
    }
}
