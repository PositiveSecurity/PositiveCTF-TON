import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { Contract, toNano } from '@ton/core';
import '@ton/test-utils';
import assert from 'assert';

export class LevelDeployer {
    blockchain: Blockchain | undefined;
    deployer: SandboxContract<TreasuryContract> | undefined;
    player: SandboxContract<TreasuryContract> | undefined;

    constructor() {}

    async init() {
        this.blockchain = await Blockchain.create();
        this.deployer = await this.blockchain.treasury('deployer');
        this.player = await this.blockchain.treasury('player');
    }

    async deployLevelFromDeployer<T extends Contract>(levelType: {
        fromInit: () => Promise<T>;
    }): Promise<SandboxContract<T>> {
        const contractInstance: any = this.blockchain!.openContract(await levelType.fromInit());

        const deployResult = await contractInstance.send(
            this.deployer!.getSender(),
            {
                value: toNano('0.05'),
            },
            { $$type: 'Deploy', queryId: 0n },
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: this.deployer!.address,
            to: contractInstance.address,
            deploy: true,
            success: true,
        });

        return contractInstance;
    }

    async deployLevelFromPlayer<T extends Contract>(levelType: {
        fromInit: () => Promise<T>;
    }): Promise<SandboxContract<T>> {
        const contractInstance: any = this.blockchain!.openContract(await levelType.fromInit());

        const deployResult = await contractInstance.send(
            this.player!.getSender(),
            {
                value: toNano('0.05'),
            },
            { $$type: 'Deploy', queryId: 0n },
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: this.player!.address,
            to: contractInstance.address,
            deploy: true,
            success: true,
        });

        return contractInstance;
    }

    async sendLevelCompleted(level: any) {
        await level.send(
            this.player!.getSender(),
            {
                value: toNano('0.05'),
            },
            'LevelCompleted',
        );
    }

    async isLevelCompleted(level: any) {
        assert(await level.getCompleted(), 'Solution is not solving the level');
    }
}
