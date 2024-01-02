import ApprovalVoting from "../contracts/ApprovalVoting.cdc"

// This transaction allows a voter to select the votes they would like to make
// and cast that vote by using the `castVote` function of the ApprovalVoting
// smart contract.

transaction(proposal: Int) {
    prepare(voter: auth(LoadValue) &Account) {
        // Take the voter's ballot our of storage
        let ballot <- voter.storage.load<@ApprovalVoting.Ballot>(
            from: /storage/Ballot
        )!

        // Vote on the proposal.
        ballot.vote(proposal: proposal)

        // Cast the vote by submitting it to the smart contract.
        ApprovalVoting.cast(ballot: <-ballot)

        log("Vote cast and tallied")
    }
}
