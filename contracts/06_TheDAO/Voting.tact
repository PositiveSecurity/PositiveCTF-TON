import "@stdlib/deploy";
import "./WalletTokenDAO.tact";
import "./Messages.tact";
const totalSupply: Int = ton("777777");
const emergencyQuorum: Int = 70;

contract Voting with Deployable {
    dao: Address;
    tokenDAO: Address;
    proposal: Address;
    votes: Votes;
    deadline: Int as uint64;
    total: Int as coins;
    voted: map<Address, Bool>;
    init(proposal: Address, tokenDAO: Address, deadline: Int){
        self.dao = sender();
        self.tokenDAO = tokenDAO;
        self.proposal = proposal;
        self.votes = Votes{for: 0, abstain: 0, against: 0};
        self.deadline = deadline;
        self.total = 0;
        self.voted = emptyMap();
    }

    receive(msg: Vote){
        require(!self.voted.exists(sender()), "You've already voted");
        let addressFromWallet: Address = contractAddress(initOf WalletTokenDAO(msg.from, self.tokenDAO));
        require(sender() == addressFromWallet, "Wrong sender");
        self.votes.for += msg.votes.for;
        self.votes.abstain += msg.votes.abstain;
        self.votes.against += msg.votes.against;
        self.total += (msg.votes.for + msg.votes.abstain) + msg.votes.against;
        self.voted.set(sender(), true);
        self.forward(msg.from, null, false, null);
    }

    receive(msg: Execute){
        nativeThrowUnless(132, sender() == self.proposal);
        require(now() >= self.deadline, "It's too early to execute");
        require(self.votes.for > self.votes.against, "Defeated");
        send(SendParameters{to: self.dao, value: 0, mode: SendRemainingValue, body: msg.msg});
    }

    receive(msg: EmergencyExecute){
        nativeThrowUnless(132, sender() == self.proposal);
        require(self.votes.for > self.votes.against, "Defeated");
        let percentage = (self.total * 100) / totalSupply;
        require(percentage >= emergencyQuorum, "Insufficient quorum");
        send(SendParameters{to: self.dao, value: 0, mode: SendRemainingValue, body: msg.msg});
    }

    get fun votes(): Votes {
        return self.votes;
    }

    get fun proposal(): Address {
        return self.proposal;
    }

    get fun deadline(): Int {
        return self.deadline;
    }

    get fun total(): Int {
        return self.total;
    }
}