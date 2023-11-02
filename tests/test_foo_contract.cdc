import Test
import "FooContract"

access(all)
fun setup() {
    let err = Test.deployContract(
        name: "FooContract",
        path: "../contracts/FooContract.cdc",
        arguments: []
    )
    Test.expect(err, Test.beNil())
}

access(all)
fun testGetIntegerTrait() {
    // Arrange
    // TODO: Uncomment the line below, to see how code coverage changes.
    let testInputs: {Int: String} = {
        -1: "Negative",
        0: "Zero",
        9: "Small",
        99: "Big",
        // 999: "Huge",
        1001: "Enormous",
        1729: "Harshad",
        8128: "Harmonic",
        41041: "Carmichael"
    }

    for input in testInputs.keys {
        // Act
        let result = FooContract.getIntegerTrait(input)

        // Assert
        Test.assertEqual(result, testInputs[input]!)
    }
}

access(all)
fun testAddSpecialNumber() {
    // Act
    FooContract.addSpecialNumber(78557, "Sierpinski")

    // Assert
    Test.assertEqual("Sierpinski", FooContract.getIntegerTrait(78557))
}
