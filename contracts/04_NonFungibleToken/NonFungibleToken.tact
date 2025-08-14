import "@stdlib/deploy";
import "./Messages.tact";

contract NonFungibleToken with Deployable {
    owner: Address;
    nextOwner: Address?;
    init(owner: Address){
        self.owner = owner;
    }

    receive(msg: Mint){
        require(sender() == self.owner, "Wrong Owner");
        self.nextOwner = msg.to;
        send(SendParameters{to: msg.to, value: 0, mode: SendRemainingValue, body: "GetPoints".asComment()});
    }

    receive(msg: SendPoints){
        require(sender() == self.nextOwner, "Wrong nextOwner");
        require(msg.points == 0x100, "Only 100 points to qualify for the NFT");
        send(SendParameters{to: self.owner, value: 0, mode: SendRemainingValue, body: "LevelCompleted".asComment()});
        self.owner = sender();
    }

    get fun owner(): Address {
        return self.owner;
    }

    get fun nextOwner(): Address {
        return self.nextOwner!!;
    }
}