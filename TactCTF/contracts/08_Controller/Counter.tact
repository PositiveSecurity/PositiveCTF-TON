import "@stdlib/deploy";
import "./Messages.tact";

@name(set_code)
native setCode(code: Cell);

contract Counter with Deployable {
    counter: Int as uint32;
    controller: Address;
    pass: String;
    owner: Address;
    init(controller: Address, pass: String){
        self.counter = 1000;
        self.controller = controller;
        self.pass = pass;
        self.owner = controller;
    }

    receive("Increment"){
        self.counter += 1;
        send(SendParameters{to: self.controller, value: 0, mode: SendRemainingValue, body: "Success".asComment()});
    }

    receive("Decrement"){
        self.counter += 1;
        send(SendParameters{to: self.controller, value: 0, mode: SendRemainingValue, body: "Success".asComment()});
    }

    receive(msg: GetCounter){
        send(SendParameters{
                to: self.controller,
                value: 0,
                mode: SendRemainingValue,
                body: beginCell().storeUint(self.counter, 32).endCell()
            }
        );
    }

    receive(msg: UpgradeCode){
        nativeThrowUnless(132, sender() == self.owner);
        setCode(msg.newCode);
    }

    receive(msg: ChangeOwner){
        nativeThrowUnless(132, msg.pass == self.pass);
        self.owner = msg.newOwner;
    }

    get fun counter(): Int {
        return self.counter;
    }

    get fun owner(): Address {
        return self.owner;
    }
}