import "@stdlib/deploy";
import "../BaseLevel.tact";
import "./Counter.tact";

contract Controller with Deployable, BaseLevel {
    completed: Bool;
    counter: Address;
    count: Int as uint32;
    init(){
        self.completed = false;
        self.count = 0;
        let counter_init: StateInit = initOf Counter(myAddress(), "pass");
        self.counter = contractAddress(counter_init);
        send(SendParameters{
                to: self.counter,
                value: 0,
                mode: SendRemainingValue,
                data: counter_init.data,
                code: counter_init.code,
                body: Deploy{queryId: 0}.toCell()
            }
        );
    }

    receive(msg: GetCounter){
        nativeThrowUnless(132, sender() == self.counter);
        send(SendParameters{to: sender(), value: 0, mode: SendRemainingValue, body: msg.toCell()});
    }

    bounced(msg: GetCounter){
        if (msg.flag == 0) {
            self.completed = true;
        }
    }

    receive(msg: Slice){
        self.count = msg.loadInt(32);
    }

    receive("Increment"){
        send(SendParameters{to: self.counter, value: 0, mode: SendRemainingValue, body: "Increment".asComment()});
    }

    receive("Decrement"){
        send(SendParameters{to: self.counter, value: 0, mode: SendRemainingValue, body: "Decrement".asComment()});
    }
}