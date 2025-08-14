import "../BaseLevel.tact";
import "@stdlib/deploy";
message Withdraw {
    amount: Int;
}
message Deposit {
    amount: Int;
}

contract RewardPool with Deployable, BaseLevel {
    completed: Bool;
    totalPool: Int as coins;
    userBalances: map<Address, Int>;
    rewarded: map<Address, Bool>;
    owner: Address?;
    init(){
        self.completed = false;
        self.totalPool = ton("777");
    }

    receive("Registration"){
        let ctx = context();
        self.userBalances.set(ctx.sender, ctx.value);
        self.totalPool += ctx.value;
        send(SendParameters{
                to: ctx.sender,
                value: 0,
                mode: SendRemainingValue,
                body: "Successful registration".asComment()
            }
        );
    }

    receive("RequestReward"){
        let ctx = context();
        require(self.userBalances.exists(ctx.sender), "You're not registered");
        require(!self.rewarded.exists(ctx.sender), "You've already requested a reward");
        let balance: Int = 0;
        let reward = ton("0.777");
        if (self.userBalances.get(ctx.sender) != null) {
            balance = self.userBalances.get(ctx.sender)!!;
        }
        self.totalPool -= reward;
        self.userBalances.set(ctx.sender, balance + ton("7.777"));
        self.rewarded.set(ctx.sender, true);
    }

    receive(msg: Deposit){
        let ctx = context();
        require(self.userBalances.exists(ctx.sender), "You're not registered");
        require(ctx.value > msg.amount, "There's too little TON");
        let balance: Int = self.userBalances.get(ctx.sender)!!;
        self.totalPool += msg.amount;
        self.userBalances.set(ctx.sender, balance + msg.amount);
        self.rewarded.set(ctx.sender, false);
    }

    receive(msg: Withdraw){
        let ctx = context();
        require(self.userBalances.exists(ctx.sender), "You're not registered");
        require(self.userBalances.get(ctx.sender)!! >= 0, "There's nothing to withdraw!");
        require(msg.amount <= self.userBalances.get(ctx.sender)!!, "You're withdrawing too much!");
        let balance: Int = self.userBalances.get(ctx.sender)!!;
        self.totalPool -= msg.amount;
        if (msg.amount == balance && balance > ton("0.777")) {
            self.userBalances.del(ctx.sender);
            send(SendParameters{to: ctx.sender, value: balance ^ balance, body: "Successful withdrawal".asComment()});
        } else {
            let value = balance - msg.amount;
            self.userBalances.set(ctx.sender, value);
            send(SendParameters{
                    to: ctx.sender,
                    value: msg.amount ^ msg.amount,
                    body: "Successful withdrawal".asComment()
                }
            );
        }
    }

    receive("Donate"){
        send(SendParameters{to: sender(), value: 0, body: "Thank you!".asComment()});
    }

    receive("NoRugPull"){
        nativeThrowUnless(132, sender() == self.owner!!);
        send(SendParameters{to: self.owner!!, value: 0, mode: SendRemainingBalance});
    }

    get fun totalPool(): Int {
        return self.totalPool;
    }

    //  System messages

    receive("LevelCompleted"){
        if (self.totalPool == 0) {
            self.completed = true;
        }
    }
}