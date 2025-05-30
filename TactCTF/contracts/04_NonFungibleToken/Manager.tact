import "../BaseLevel.tact";
import "@stdlib/deploy";
import "./NonFungibleToken.tact";
import "./Student.tact";
import "./Messages.tact";

contract Manager with Deployable, BaseLevel {
    completed: Bool;
    nft: Address;
    init(){
        self.completed = false;
        let initStudent = initOf Student(myAddress());
        let addressStudent: Address = contractAddress(initStudent);
        send(SendParameters{
                to: addressStudent,
                value: ton("0.02"),
                mode: SendIgnoreErrors,
                code: initStudent.code,
                data: initStudent.data,
                body: Deploy{queryId: 0}.toCell()
            }
        );
        let level_init: StateInit = initOf NonFungibleToken(myAddress());
        self.nft = contractAddress(level_init);
        send(SendParameters{
                to: self.nft,
                value: ton("0.02"),
                mode: SendIgnoreErrors,
                data: level_init.data,
                code: level_init.code,
                body: Deploy{queryId: 0}.toCell()
            }
        );
    }

    receive("RequestReward"){
        send(SendParameters{to: sender(), value: 0, mode: SendRemainingValue, body: "GetPoints".asComment()});
    }

    receive(msg: SendPoints){
        require(msg.points == 100, "Only 100 points to qualify for the NFT");
        send(SendParameters{to: self.nft, value: 0, mode: SendRemainingValue, body: Mint{to: msg.student}.toCell()});
    }

    get fun nft(): Address {
        return self.nft;
    }

    receive("LevelCompleted"){
        require(sender() == self.nft, "Wrong sender");
        self.completed = true;
    }
}