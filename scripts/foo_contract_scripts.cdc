import FooContract from "../contracts/FooContract.cdc"

access(all)
fun main(): Bool {
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
        let result = FooContract.getIntegerTrait(input)
        assert(result == testInputs[input])
    }

    FooContract.addSpecialNumber(78557, "Sierpinski")

    assert("Sierpinski" == FooContract.getIntegerTrait(78557))

    return true
}
