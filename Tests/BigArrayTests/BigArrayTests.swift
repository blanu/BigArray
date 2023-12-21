import XCTest

import BigNumber

@testable import BigArray


final class BigArrayTests: XCTestCase
{
    func testBigArray() throws
    {
        var array: BigArray<BInt> = [BInt(1), BInt(2), BInt(3), BInt(4)]
        array.append(BInt(5))
        array.remove(at: BInt(0))

        XCTAssertEqual(array[BInt(0)], BInt(2))
        XCTAssertEqual(array[BInt(3)], BInt(5))
    }

    func testNestedArrayElement() throws
    {
        let correct: Int = 23
        let array = NestedArray<Int>.element(23)
        guard let result = array.element else
        {
            XCTFail()
            return
        }

        XCTAssertEqual(result, correct)
    }

    func testNestedArrayNested() throws
    {
        let correct: Int = 23
        let array = NestedArray<Int>.array([.element(23)])
        guard let subarray = array.array else
        {
            XCTFail()
            return
        }

        guard let first = subarray.first else
        {
            XCTFail()
            return
        }

        guard let result = first.element else
        {
            XCTFail()
            return
        }

        XCTAssertEqual(result, correct)
    }

    func testNestedArrayGetElement() throws
    {
        let correct: Int = 23
        let array = NestedArray<Int>.element(23)
        let lens: [Int] = []

        guard let element = array.get(lens) else
        {
            XCTFail()
            return
        }

        guard let result = element.element else
        {
            XCTFail()
            return
        }

        XCTAssertEqual(result, correct)
    }

    func testNestedArrayGetNested() throws
    {
        let correct: Int = 23
        let array = NestedArray<Int>.array([.element(23)])
        let lens: [Int] = [0]

        guard let element = array.get(lens) else
        {
            XCTFail()
            return
        }

        guard let result = element.element else
        {
            XCTFail()
            return
        }

        XCTAssertEqual(result, correct)
    }

    func testNestedArrayGetNested2() throws
    {
        let correct: Int = 1
        let array: NestedArray<Int> = .array([.array([.element(23)])])
        let lens: [Int] = [0]

        guard let result = array.get(lens) else
        {
            XCTFail()
            return
        }

        XCTAssertEqual(result.count, correct)
    }

    func testNestedArrayGetNestedNested() throws
    {
        let correct: Int = 23
        let array: NestedArray<Int> = .array([.array([.element(23)])])
        let lens: [Int] = [0, 0]

        guard let element = array.get(lens) else
        {
            XCTFail()
            return
        }

        guard let result = element.element else
        {
            XCTFail()
            return
        }

        XCTAssertEqual(result, correct)
    }
}
