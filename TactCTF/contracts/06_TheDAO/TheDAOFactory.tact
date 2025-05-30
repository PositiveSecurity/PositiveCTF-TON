import "@stdlib/deploy";
import "../../../Common/BaseFactory.tact";
import "../../../Common/Messages.tact";
import "./TheDAO.tact";
import "./MasterTokenDAO.tact";

// npx blueprint build TheDAOFactory
contract TheDAOFactory with Deployable, BaseFactory {
    positiveCTF: Address;
    seqno: Int;
    score: Int;
    name: String;
    init(positiveCTF: Address, score: Int){
        self.seqno = 0;
        self.positiveCTF = positiveCTF;
        self.score = score;
        self.name = "TheDAO";
    }

    override fun createLevel() {
        require(context().value >= ton("0.2"), "Error");
        // deploy MasterTokenDAO
        let initMasterTokenDAO: StateInit = initOf MasterTokenDAO(sender(), self.seqno);
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
        // deploy TheDAO
        let initTheDAO: StateInit = initOf TheDAO(myAddress(), sender(), self.seqno, addressMasterTokenDAO);
        let addressTheDAO: Address = contractAddress(initTheDAO);
        send(SendParameters{
                to: addressTheDAO,
                value: ton("0.11"),
                code: initTheDAO.code,
                data: initTheDAO.data,
                body: "Donate".asComment()
            }
        );
        send(SendParameters{
                to: self.positiveCTF,
                value: ton("0.03"),
                body: CurrentInstance{name: self.name, instance: addressTheDAO, player: sender()}.toCell()
            }
        );
    }

    override fun submitLevel(msg: LevelCompleted) {
        let addressMasterTokenDAO: Address = contractAddress(initOf MasterTokenDAO(msg.player, msg.seqno));
        let addressTheDAO: Address = contractAddress(initOf TheDAO(myAddress(),
                msg.player,
                msg.seqno,
                addressMasterTokenDAO
            )
        );
        require(sender() == addressTheDAO, "Wrong sender");
        send(SendParameters{
                to: self.positiveCTF,
                value: 0,
                mode: SendRemainingValue,
                body: SubmitLevel{name: self.name, player: msg.player, score: self.score}.toCell()
            }
        );
    }
}