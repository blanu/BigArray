import XCTest

import BigNumber

@testable import BigArray


final class BigArrayTests: XCTestCase
{
    func testBigArray() throws
    {
        var array: BigArray = [BInt(1), BInt(2), BInt(3), BInt(4)]
        array.append(BInt(5))
        array.remove(at: BInt(0))

        XCTAssertEqual(array[BInt(0)], BInt(2))
        XCTAssertEqual(array[BInt(3)], BInt(5))
    }
}
