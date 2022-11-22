//
//  BigNum.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/21/22.
//

import Foundation

import BigNumber

public enum BigNum: Equatable, Hashable, Codable
{
    case int(BInt)
    case double(Double)
}

extension BigNum
{
    public var int: BInt?
    {
        switch self
        {
            case .int(let value):
                return value

            default:
                return nil
        }
    }

    public var double: Double?
    {
        switch self
        {
            case .double(let value):
                return value

            default:
                return nil
        }
    }
}

extension BigNum: Comparable
{
    public static func ==(lhs: BigNum, rhs: BigNum) -> Bool
    {
        switch lhs
        {
            case .int(let left):
                switch rhs
                {
                    case .int(let right):
                        return left == right

                    case .double(let right):
                        return BDouble(left) == BDouble(right)
                }

            case .double(let left):
                switch rhs
                {
                    case .int(let right):
                        return BDouble(left) == BDouble(right)

                    case .double(let right):
                        return left == right

                }
        }
    }

    public static func <(lhs: BigNum, rhs: BigNum) -> Bool
    {
        switch lhs
        {
            case .int(let left):
                switch rhs
                {
                    case .int(let right):
                        return left < right

                    case .double(let right):
                        return BDouble(left) < BDouble(right)
                }

            case .double(let left):
                switch rhs
                {
                    case .int(let right):
                        return BDouble(left) < BDouble(right)

                    case .double(let right):
                        return left < right

                }
        }
    }
}
