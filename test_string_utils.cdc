import Test

pub var blockchain = Test.newEmulatorBlockchain()
pub var account = blockchain.createAccount()

pub fun setup() {
    blockchain.useConfiguration(Test.Configuration({
        "ArrayUtils.cdc": account.address,
        "StringUtils.cdc": account.address
    }))

    var arrayUtils = Test.readFile("ArrayUtils.cdc")
    var err = blockchain.deployContract(
        name: "ArrayUtils",
        code: arrayUtils,
        account: account,
        arguments: []
    )

    Test.assert(err == nil)

    var stringUtils = Test.readFile("StringUtils.cdc")
    err = blockchain.deployContract(
        name: "StringUtils",
        code: stringUtils,
        account: account,
        arguments: []
    )

    Test.assert(err == nil)
}

pub fun testFormat() {
    let returnedValue = executeScript("string_utils_format.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testExplode() {
    let returnedValue = executeScript("string_utils_explode.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testTrimLeft() {
    let returnedValue = executeScript("string_utils_trim_left.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testTrim() {
    let returnedValue = executeScript("string_utils_trim.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testReplaceAll() {
    let returnedValue = executeScript("string_utils_replace_all.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testHasPrefix() {
    let returnedValue = executeScript("string_utils_has_prefix.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testHasSuffix() {
    let returnedValue = executeScript("string_utils_has_suffix.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testIndex() {
    let returnedValue = executeScript("string_utils_index.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testCount() {
    let returnedValue = executeScript("string_utils_count.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testContains() {
    let returnedValue = executeScript("string_utils_contains.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testSubstringUntil() {
    let returnedValue = executeScript("string_utils_substring_until.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testSplit() {
    let returnedValue = executeScript("string_utils_split.cdc")
    Test.assert(returnedValue, message: "found: false")
}

pub fun testJoin() {
    let returnedValue = executeScript("string_utils_join.cdc")
    Test.assert(returnedValue, message: "found: false")
}

priv fun executeScript(_ scriptPath: String): Bool {
    var script = Test.readFile(scriptPath)
    let value = blockchain.executeScript(script, [])

    Test.assert(value.status == Test.ResultStatus.succeeded)

    return value.returnValue! as! Bool
}
