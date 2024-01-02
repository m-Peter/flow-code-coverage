import Test
import BlockchainHelpers
import "ApprovalVoting"

access(all) let admin = Test.getAccount(0x0000000000000007)
access(all) let voter = Test.createAccount()

access(all)
fun setup() {
    let err = Test.deployContract(
        name: "ApprovalVoting",
        path: "../contracts/ApprovalVoting.cdc",
        arguments: []
    )
    Test.expect(err, Test.beNil())
}

access(all)
fun testInitializeEmptyProposals() {
    let proposals: [String] = []
    let txResult = executeTransaction(
        "../transactions/initialize_proposals.cdc",
        [proposals],
        admin
    )

    Test.expect(txResult, Test.beFailed())
    Test.assertError(
        txResult,
        errorMessage: "Cannot initialize with no proposals"
    )
}

access(all)
fun testInitializeProposals() {
    let proposals = [
        "Longer Shot Clock",
        "Trampolines instead of hardwood floors"
    ]
    let txResult = executeTransaction(
        "../transactions/initialize_proposals.cdc",
        [proposals],
        admin
    )

    Test.expect(txResult, Test.beSucceeded())

    let events = Test.eventsOfType(Type<ApprovalVoting.ProposalsInitialized>())
    Test.assertEqual(1, events.length)
}

access(all)
fun testProposalsImmutability() {
    let proposals = ["Add some more options"]
    let txResult = executeTransaction(
        "../transactions/initialize_proposals.cdc",
        [proposals],
        admin
    )

    Test.expect(txResult, Test.beFailed())
    Test.assertError(
        txResult,
        errorMessage: "Proposals can only be initialized once"
    )
}

access(all)
fun testIssueBallot() {
    let code = Test.readFile("../transactions/issue_ballot.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address, voter.address],
        signers: [admin, voter],
        arguments: []
    )

    let txResult = Test.executeTransaction(tx)

    Test.expect(txResult, Test.beSucceeded())
}

access(all)
fun testCastVoteOnMissingProposal() {
    let txResult = executeTransaction(
        "../transactions/cast_vote.cdc",
        [2],
        voter
    )

    Test.expect(txResult, Test.beFailed())
    Test.assertError(
        txResult,
        errorMessage: "Cannot vote for a proposal that doesn't exist"
    )
}

access(all)
fun testCastVote() {
    let txResult = executeTransaction(
        "../transactions/cast_vote.cdc",
        [1],
        voter
    )

    Test.expect(txResult, Test.beSucceeded())

    let events = Test.eventsOfType(Type<ApprovalVoting.VoteCasted>())
    Test.assertEqual(1, events.length)

    let evt = events[0] as! ApprovalVoting.VoteCasted
    Test.assertEqual("Trampolines instead of hardwood floors", evt.proposal)
}

access(all)
fun testViewVotes() {
    let scriptResult = executeScript("../scripts/view_votes.cdc", [])
    let votes = (scriptResult.returnValue as! {Int: Int}?)!

    let expected = {0: 0, 1: 1}
    Test.assertEqual(expected, votes)
}
