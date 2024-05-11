//
//  Complex+Extensions.swift
//
//
//  Created by Dr. Brandon Wiley on 5/10/24.
//

import Foundation

import Numerics

// Of course, complex numbers do not have a complete ordering like integers.
// However, Comparable is used for a variety of orderings, such as lexical ordering of text.
// It is useful to a working definition of a partial ordering for the Complex type even if it
// is not mathematically sound.
// Here we use lexical ordering by comparing first the real part and then the imaginary part.
// While there are other options available, we have to start somewhere.
extension Complex: Comparable
{
    public static func < (lhs: Complex<RealType>, rhs: Complex<RealType>) -> Bool
    {
        return (lhs.real < rhs.real) && (lhs.imaginary < rhs.imaginary)
    }
}
