import ApprovalVoting from "../contracts/ApprovalVoting.cdc"

// This transaction allows the administrator of the Voting contract
// to create a new ballot and store it in a voter's account.
// The voter and the administrator have to both sign the transaction
// so it can access their storage.

transaction {
    prepare(admin: auth(BorrowValue) &Account, voter: auth(SaveValue) &Account) {
        // Borrow a reference to the admin Resource
        let adminRef = admin.storage.borrow<&ApprovalVoting.Administrator>(
            from: /storage/VotingAdmin
        )!

        // Create a new Ballot by calling the issueBallot
        // function of the admin Reference
        let ballot <- adminRef.issueBallot()

        // store that ballot in the voter's account storage
        voter.storage.save<@ApprovalVoting.Ballot>(<-ballot, to: /storage/Ballot)

        log("Ballot transferred to voter")
    }
}
