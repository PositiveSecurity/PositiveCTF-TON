import "../BaseLevel.tact";
import "@stdlib/deploy";
import "./Dog.tact";
message Chain {
    timestamp: Int;
}

contract ChainDog with Deployable, BaseLevel {
    completed: Bool;
    dog: Address;
    timestamp: Int;
    init(){
        self.completed = false;
        self.timestamp = now() + 864000;
        let initDog: StateInit = initOf Dog(myAddress());
        let addr: Address = contractAddress(initDog);
        self.dog = addr;
        send(SendParameters{
                to: addr,
                value: 0,
                mode: SendRemainingValue,
                code: initDog.code,
                data: initDog.data,
                body: Deploy{queryId: 0}.toCell()
            }
        );
    }

    receive("RunAway"){
        nativeThrowUnless(132, sender() == self.dog);
        self.completed = true;
    }

    receive(msg: Chain){
        require(msg.timestamp > self.timestamp, "The dog is still on the chain");
        let chain: Cell = beginCell().storeAddress(myAddress()).storeUint(now(), 32).storeUint(msg.timestamp,
            64
        ).storeUint(self.timestamp, 32).endCell();
        msg.timestamp = msg.timestamp;
        send(SendParameters{to: self.dog, value: 0, mode: SendRemainingValue, body: chain});
    }

    receive("Unchain"){
        require(self.timestamp < now(), "The dog is still on the chain");
        self.completed = true;
    }

    get fun timestamp(): Int {
        return self.timestamp;
    }
}