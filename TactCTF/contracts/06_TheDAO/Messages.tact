// Voting
struct Votes {
    for: Int as coins;
    abstain: Int as coins;
    against: Int as coins;
}
message Vote {
    from: Address;
    votes: Votes;
}
message Execute {
    msg: Cell;
}
message EmergencyExecute {
    msg: Cell;
}
// WalletTokenDAO
message SendVote {
    voting: Address;
    votes: Votes;
}
message Transfer {
    to: Address;
    value: Int as coins;
}
message InternalTransfer {
    value: Int as coins;
    from: Address;
}
// TheDAO
message Grant {
    proposal: Address;
    to: Address;
}
message CreateProposal {
    proposal: Address;
}
// MasterTokenDAO
message Mint {
    to: Address;
    value: Int as coins;
}