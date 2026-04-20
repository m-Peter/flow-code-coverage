import "SolidityContractsRegistry"

access(all)
fun main(contractName: String): [UInt8; 20]? {
    return SolidityContractsRegistry.contractRegistry[contractName]
}
