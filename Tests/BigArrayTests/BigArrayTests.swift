import XCTest

import BigNumber

@testable import BigArray


final class BigArrayTests: XCTestCase
{
    func testBigArray() throws
    {
        var array: BigArray = [.int(BInt(1)), .int(BInt(2)), .int(BInt(3)), .int(BInt(4))]
        array.append(.int(BInt(5)))
        array.remove(at: .int(BInt(0)))

        XCTAssertEqual(array[.int(BInt(0))], .int(BInt(2)))
        XCTAssertEqual(array[.int(BInt(3))], .int(BInt(5)))
    }
}
