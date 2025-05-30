import "@stdlib/deploy";

contract Dog with Deployable {
    owner: Address;
    init(owner: Address){
        self.owner = owner;
    }

    receive(msg: Slice){
        let address: Address = msg.loadAddress();
        nativeThrowUnless(132, address == self.owner && sender() == self.owner);
        let time: Int = msg.loadUint(32);
        let now: Int = msg.loadUint(32);
        let timestamp: Int = msg.loadUint(32);
        if (now > timestamp && time < now) {
            send(SendParameters{to: self.owner, value: 0, mode: SendRemainingValue, body: "RunAway".asComment()});
        }
    }
}