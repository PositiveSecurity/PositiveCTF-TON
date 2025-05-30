import "../BaseLevel.tact";
import "@stdlib/deploy";
import "./Voting.tact";
import "./MasterTokenDAO.tact";
import "./Messages.tact";
const period: Int = 864000; // 10 days

contract TheDAO with Deployable, BaseLevel {
    completed: Bool;
    tokenDAO: Address;
    proposals: map<Address, Address>;
    init(){
        self.completed = false;
        // deploy MasterTokenDAO
        let initMasterTokenDAO: StateInit = initOf MasterTokenDAO(sender());
        let addressMasterTokenDAO: Address = contractAddress(initMasterTokenDAO);
        // deploy token + init mint
        send(SendParameters{
                to: addressMasterTokenDAO,
                value: ton("0.03"),
                code: initMasterTokenDAO.code,
                data: initMasterTokenDAO.data,
                body: Mint{to: sender(), value: ton("222333")}.toCell()
            }
        );
        self.tokenDAO = addressMasterTokenDAO;
        self.proposals = emptyMap();
    }

    receive("Donate"){
        emit("Thank you!".asComment());
    }

    receive(msg: CreateProposal){
        let initVoting: StateInit = initOf Voting(msg.proposal, self.tokenDAO, now() + period);
        let addrVoting: Address = contractAddress(initVoting);
        self.proposals.set(msg.proposal, addrVoting);
        send(SendParameters{
                to: addrVoting,
                value: 0,
                mode: SendRemainingValue,
                code: initVoting.code,
                data: initVoting.data,
                body: Deploy{queryId: 0}.toCell()
            }
        );
    }

    receive(msg: Grant){
        nativeThrowUnless(132, sender() == self.proposals.get(msg.proposal));
        send(SendParameters{to: msg.to, value: 0, mode: SendRemainingBalance});
    }

    get fun proposals(): map<Address, Address> {
        return self.proposals;
    }

    get fun voting(proposal: Address): Address {
        return self.proposals.get(proposal)!!;
    }

    get fun balance(): Int {
        return myBalance();
    }

    receive("LevelCompleted"){
        if ((myBalance() - context().value) == 0) {
            self.completed = true;
        }
    }
}