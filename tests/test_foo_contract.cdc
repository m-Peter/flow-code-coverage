import Test
import "FooContract"

pub let foo = FooContract()

pub fun testGetIntegerTrait() {
    // Arrange
    let testInputs: {Int: String} = {
        -1: "Negative",
        0: "Zero",
        9: "Small",
        99: "Big",
        999: "Huge",
        1001: "Enormous",
        1729: "Harshad",
        8128: "Harmonic",
        41041: "Carmichael"
    }

    for input in testInputs.keys {
        // Act
        let result = foo.getIntegerTrait(input)

        // Assert
        Test.assertEqual(result, testInputs[input]!)
    }
}

pub fun testAddSpecialNumber() {
    // Act
    foo.addSpecialNumber(78557, "Sierpinski")

    // Assert
    Test.assertEqual("Sierpinski", foo.getIntegerTrait(78557))
}
