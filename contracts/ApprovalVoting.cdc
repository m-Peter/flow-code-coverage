///
/// In this example, we want to create a simple approval voting
/// contract where a polling place issues ballots to addresses.
///
/// To run a vote, the Admin deploys the smart contract, then
/// initializes the proposals using the `initialize_proposals.cdc`
/// transaction.
/// The array of proposals cannot be modified after it has been
/// initialized.
///
/// Then they will give ballots to users by using the `issue_ballot.cdc`
/// transaction.
///
/// Every user with a ballot is allowed to approve any number of proposals.
/// A user can choose their votes and cast them with the `cast_vote.cdc`
/// transaction.
///
access(all) contract ApprovalVoting {

    // List of proposals to be approved.
    access(all) var proposals: [String]

    // Number of votes per proposal.
    access(all) let votes: {Int: Int}

    // Event emitted when proposals are initialized by the admin.
    access(all) event ProposalsInitialized(proposals: [String])

    // Event emitted when users cast a vote on a proposal.
    access(all) event VoteCasted(proposal: String)

    /// This is the resource that is issued to users.
    /// When a user gets a Ballot object, they call the `vote` function
    /// to include their votes, and then cast it in the smart contract
    /// using the `cast` function to have their vote included in the polling.
    access(all) resource Ballot {

        // Array of all the proposals.
        access(all) let proposals: [String]

        // Corresponds to an array index in proposals after a vote.
        access(all) let choices: {Int: Bool}

        init() {
            self.proposals = ApprovalVoting.proposals
            self.choices = {}

            // Set each choice to false.
            var i = 0
            while i < self.proposals.length {
                self.choices[i] = false
                i = i + 1
            }
        }

        // Modifies the ballot to indicate which proposals it is voting for.
        access(all)
        fun vote(proposal: Int) {
            pre {
                proposal <= (self.proposals.length - 1): "Cannot vote for a proposal that doesn't exist"
            }
            self.choices[proposal] = true
        }
    }

    /// Resource that the Administrator of the vote controls to initialize
    /// the proposals and to pass out ballot resources to voters.
    access(all) resource Administrator {

        // Function to initialize all the proposals for the voting.
        access(all)
        fun initializeProposals(_ proposals: [String]) {
            pre {
                ApprovalVoting.proposals.length == 0: "Proposals can only be initialized once"
                proposals.length > 0: "Cannot initialize with no proposals"
            }
            ApprovalVoting.proposals = proposals

            // Set each tally of votes to zero.
            var i = 0
            while i < proposals.length {
                ApprovalVoting.votes[i] = 0
                i = i + 1
            }

            emit ProposalsInitialized(proposals: proposals)
        }

        // The admin calls this function to create a new Ballot
        // that can be transferred to another user.
        access(all)
        fun issueBallot(): @Ballot {
            return <-create Ballot()
        }
    }

    // A user moves their ballot to this function in the contract where
    // its votes are tallied and the ballot is destroyed.
    access(all)
    fun cast(ballot: @Ballot) {
        var proposal = ""
        var index = 0
        // Look through the ballot.
        while index < self.proposals.length {
            if ballot.choices[index]! {
                // Tally the vote if it is approved.
                self.votes[index] = self.votes[index]! + 1
                proposal = self.proposals[index]
            }
            index = index + 1
        }

        // Destroy the ballot because it has been tallied.
        destroy ballot

        emit VoteCasted(proposal: proposal)
    }

    // Initializes the contract by setting the proposals and votes
    // to empty and creating a new Admin resource to put in storage.
    init() {
        self.proposals = []
        self.votes = {}

        self.account.storage.save<@Administrator>(
            <-create Administrator(),
            to: /storage/VotingAdmin
        )
    }
}
