import "EVM"

transaction(addressBytes: [UInt8; 20]) {
    let coa: auth(EVM.Call) &EVM.CadenceOwnedAccount

    prepare(signer: auth(Storage) &Account) {
        self.coa = signer.storage.borrow<auth(EVM.Call) &EVM.CadenceOwnedAccount>(
            from: /storage/evm
        ) ?? panic("Could not borrow reference to the COA!")
    }

    execute {
        let data = EVM.encodeABIWithSignature("multiply(uint256)", [UInt256(6)])
        let txResult = self.coa.call(
            to: EVM.EVMAddress(bytes: addressBytes),
            data: data,
            gasLimit: 35000,
            value: EVM.Balance(attoflow: 0)
        )

        assert(
            txResult.status == EVM.Status.successful,
            message: txResult.errorCode.toString()
        )
        
        let returnedValues = EVM.decodeABI(types: [Type<UInt256>()], data: txResult.data)
        let value = returnedValues[0] as! UInt256
        assert(value == 42) // 6 * 7 = 42
    }
}
