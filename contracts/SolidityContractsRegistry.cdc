access(all) contract SolidityContractsRegistry {

    access(all) let contractRegistry: {String: [UInt8; 20]}

    access(all) event ContractRegistered(name: String, address: [UInt8; 20])

    access(all)
    fun registerContract(name: String, address: [UInt8; 20]) {
        self.contractRegistry[name] = address
        emit ContractRegistered(name: name, address: address)
    }

    init() {
        self.contractRegistry = {}
    }
}
