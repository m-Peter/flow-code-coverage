import ApprovalVoting from "../contracts/ApprovalVoting.cdc"

// This script allows anyone to read the tallied votes for each proposal.

access(all)
fun main(): {Int: Int} {
    return ApprovalVoting.votes
}
