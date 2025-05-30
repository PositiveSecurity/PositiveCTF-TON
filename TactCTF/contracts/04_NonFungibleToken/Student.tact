import "@stdlib/deploy";
import "./Messages.tact";

contract Student with Deployable {
    points: Int = 100;
    manager: Address;
    init(manager: Address){
        self.manager = manager;
    }

    receive("GetPoints"){
        send(SendParameters{
                to: sender(),
                value: 0,
                mode: SendRemainingValue,
                body: SendPoints{student: myAddress(), points: self.points}.toCell()
            }
        );
    }

    receive("RequestReward"){
        send(SendParameters{to: self.manager, value: 0, mode: SendRemainingValue, body: "RequestReward".asComment()});
    }
}