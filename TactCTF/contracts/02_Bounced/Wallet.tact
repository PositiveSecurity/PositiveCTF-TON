import "@stdlib/deploy";
import "./Messages.tact";

contract Wallet with Deployable {
    stacking: Address;
    balance: Int as coins;
    init(stacking: Address){
        self.stacking = stacking;
        self.balance = ton("100");
    }

    receive(msg: Deposit){
        nativeThrowUnless(132, sender() == self.stacking);
        self.balance += msg.amount;
    }

    receive(msg: Withdraw){
        nativeThrowUnless(132, sender() == self.stacking);
        require(self.balance >= msg.amount, "Insufficient balance!");
        self.balance -= msg.amount;
    }

    get fun balance(): Int {
        return self.balance;
    }
}