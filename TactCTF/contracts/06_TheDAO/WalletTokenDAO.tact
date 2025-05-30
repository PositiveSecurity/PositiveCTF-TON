import "@stdlib/deploy";
import "@stdlib/ownable";
import "./Messages.tact";

contract WalletTokenDAO with Deployable, Ownable {
    owner: Address;
    master: Address;
    balance: Int as coins;
    init(owner: Address, master: Address){
        self.balance = 0;
        self.owner = owner;
        self.master = master;
    }

    receive(msg: Transfer){
        self.requireOwner();
        require(self.balance >= msg.value, "Insufficient balance");
        self.balance -= msg.value;
        let initWalletTokenDAO: StateInit = initOf WalletTokenDAO(msg.to, self.master);
        let addressToWallet: Address = contractAddress(initWalletTokenDAO);
        send(SendParameters{
                to: addressToWallet,
                value: 0,
                code: initWalletTokenDAO.code,
                data: initWalletTokenDAO.data,
                mode: SendRemainingValue,
                body: InternalTransfer{from: sender(), value: msg.value}.toCell()
            }
        );
    }

    receive(msg: InternalTransfer){
        let addressFromWallet: Address = contractAddress(initOf WalletTokenDAO(msg.from, self.master));
        require(sender() == self.master || sender() == addressFromWallet, "Wrong sender");
        self.balance += msg.value;
        send(SendParameters{to: self.owner, value: 0, mode: SendRemainingValue, body: "Minted".asComment()});
    }

    bounced(msg: bounced<InternalTransfer>){
        self.balance += msg.value;
    }

    receive(msg: SendVote){
        self.requireOwner();
        let total = (msg.votes.for + msg.votes.abstain) + msg.votes.against;
        require(self.balance >= total, "Insufficient balance");
        send(SendParameters{
                to: msg.voting,
                value: 0,
                mode: SendRemainingValue,
                body: Vote{from: sender(), votes: msg.votes}.toCell()
            }
        );
    }

    get fun balance(): Int {
        return self.balance;
    }
}