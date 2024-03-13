import "EVM"
import "SolidityContractsRegistry"

transaction(contractName: String, contractCode: String) {
    let coa: auth(EVM.Deploy) &EVM.CadenceOwnedAccount

    prepare(signer: auth(Storage) &Account) {
        self.coa = signer.storage.borrow<auth(EVM.Deploy) &EVM.CadenceOwnedAccount>(
            from: /storage/evm
        ) ?? panic("Could not borrow reference to the COA!")
    }

    execute {
        let contractAddress = self.coa.deploy(
            code: contractCode.decodeHex(),
            gasLimit: 110000,
            value: EVM.Balance(attoflow: 0)
        )

        SolidityContractsRegistry.registerContract(
            name: contractName,
            address: contractAddress.bytes
        )
    }
}
