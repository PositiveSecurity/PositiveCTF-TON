import "../BaseLevel.tact";
import "@stdlib/deploy";
import "./Wallet.tact";
import "./Messages.tact";

contract Stacking with Deployable, BaseLevel {
    completed: Bool;
    balance: Int as coins;
    init(){
        self.completed = false;
        self.balance = ton("10");
        let initWallet: StateInit = initOf Wallet(myAddress());
        let addrWallet: Address = contractAddress(initWallet);
        send(SendParameters{
                to: addrWallet,
                value: 0,
                code: initWallet.code,
                data: initWallet.data,
                mode: SendRemainingValue,
                body: Deploy{queryId: 0}.toCell()
            }
        );
    }

    bounced(msg: Deposit){
        self.balance += msg.amount;
        self.balance += ton("1");
    }

    bounced(msg: Withdraw){
        self.balance -= msg.amount;
        self.balance += ton("1");
    }

    receive(msg: Withdraw){
        require(self.balance >= msg.amount, "Insufficient balance!");
        self.balance -= msg.amount;
        let addr: Address = contractAddress(initOf Wallet(myAddress()));
        send(SendParameters{
                to: addr,
                value: 0,
                bounce: true,
                mode: SendRemainingValue,
                body: Deposit{amount: msg.amount}.toCell()
            }
        );
    }

    receive(msg: Deposit){
        self.balance += msg.amount;
        let addr: Address = contractAddress(initOf Wallet(myAddress()));
        send(SendParameters{
                to: addr,
                value: 0,
                bounce: true,
                mode: SendRemainingValue,
                body: Withdraw{amount: msg.amount}.toCell()
            }
        );
    }

    receive("LevelCompleted"){
        require(self.balance == ton("10000"), "Insufficient balance!");
        self.completed = true;
    }

    get fun balance(): Int {
        return self.balance;
    }
}