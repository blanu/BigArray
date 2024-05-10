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
    var one: any Numeric { get }
}

public protocol HasZero
{
    var zero: any Numeric { get }
}

extension BInt: HasOne
{
    public var one: any Numeric
    {
        return BInt(1)
    }
}

extension BInt: HasZero
{
    public var zero: any Numeric
    {
        return BInt(0)
    }
}
