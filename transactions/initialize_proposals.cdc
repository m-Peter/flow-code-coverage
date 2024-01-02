import ApprovalVoting from "../contracts/ApprovalVoting.cdc"

// This transaction allows the Administrator of the Voting contract
// to create new proposals for voting and save them to the smart contract.

transaction(proposals: [String]) {
    prepare(admin: auth(BorrowValue) &Account) {
        // Borrow a reference to the admin Resource.
        let adminRef = admin.storage.borrow<&ApprovalVoting.Administrator>(
            from: /storage/VotingAdmin
        )!

        // Call the `initializeProposals` function to create the proposals
        // array as an array of strings.
        adminRef.initializeProposals(proposals)

        log("Proposals Initialized!")
    }

    post {
        ApprovalVoting.proposals.length == proposals.length
    }
}
