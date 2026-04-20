import Test
import BlockchainHelpers

access(all) let serviceAccount = Test.serviceAccount()

access(all)
fun setup() {
    let err = Test.deployContract(
        name: "SolidityContractsRegistry",
        path: "../contracts/SolidityContractsRegistry.cdc",
        arguments: []
    )
    Test.expect(err, Test.beNil())
}

access(all)
fun testCreateCOA() {
    let txResult = executeTransaction(
        "../transactions/create_coa.cdc",
        [750.0],
        serviceAccount
    )

    Test.expect(txResult, Test.beSucceeded())
}

access(all)
fun testDeployMultiply7Contract() {
    // contract Multiply7 {
    //     event Print(uint);
    //     function multiply(uint input) returns (uint) {
    //         Print(input * 7);
    //         return input * 7;
    //     }
    // }
    // ABI for the above Solidity contract
    let contractCode = "6060604052341561000f57600080fd5b60eb8061001d6000396000f300606060405260043610603f576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063c6888fa1146044575b600080fd5b3415604e57600080fd5b606260048080359060200190919050506078565b6040518082815260200191505060405180910390f35b60007f24abdb5865df5079dcc5ac590ff6f01d5c16edbc5fab4e195d9febd1114503da600783026040518082815260200191505060405180910390a16007820290509190505600a165627a7a7230582040383f19d9f65246752244189b02f56e8d0980ed44e7a56c0b200458caad20bb0029"
    let txResult = executeTransaction(
        "../transactions/deploy_solidity_contract.cdc",
        ["Multiply7", contractCode],
        serviceAccount
    )

    Test.expect(txResult, Test.beSucceeded())
}

access(all)
fun testCallMultiply7() {
    let scriptResult = executeScript(
        "../scripts/solidity_contract_address.cdc",
        ["Multiply7"]
    )
    Test.expect(scriptResult, Test.beSucceeded())
    let contractAddress = (scriptResult.returnValue as! [UInt8; 20]?)!
    
    let txResult = executeTransaction(
        "../transactions/solidity_contract_call.cdc",
        [contractAddress],
        serviceAccount
    )

    Test.expect(txResult, Test.beSucceeded())
}
