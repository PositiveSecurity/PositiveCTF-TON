import "@stdlib/deploy";
import "@stdlib/ownable";
import "./WalletTokenDAO.tact";

contract MasterTokenDAO with Deployable, Ownable {
    owner: Address;
    totalSupply: Int as coins; // totalSupply = 777777
    init(player: Address){
        self.totalSupply = 777777;
        self.owner = sender();
    }

    receive(msg: Mint){
        self.requireOwner();
        let initWalletTokenDAO: StateInit = initOf WalletTokenDAO(msg.to, myAddress());
        let addressToWallet: Address = contractAddress(initWalletTokenDAO);
        send(SendParameters{
                to: addressToWallet,
                value: 0,
                code: initWalletTokenDAO.code,
                data: initWalletTokenDAO.data,
                mode: SendRemainingValue,
                body: InternalTransfer{from: sender(), value: msg.value}.toCell()
            }
        );
    }

    get fun totalSupply(): Int {
        return self.totalSupply;
    }
}