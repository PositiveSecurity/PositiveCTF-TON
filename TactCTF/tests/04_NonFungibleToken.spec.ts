import { SandboxContract } from '@ton/sandbox';
import '@ton/test-utils';

import { LevelDeployer } from './LevelDeployer';
import { Manager } from '../build/NonFungibleToken/NonFungibleToken_Manager';

// npx blueprint test 04_NonFungibleToken.spec.ts
describe('NonFungibleToken', () => {
    let level: SandboxContract<Manager>;
    let levelDeployer: LevelDeployer;

    beforeEach(async () => {
        levelDeployer = new LevelDeployer();
        await levelDeployer.init();
        level = await levelDeployer.deployLevelFromDeployer(Manager);
    });

    it('Eploit Level', async () => {
        /* EXPLOIT */
        await exploit();

        /* SOLUTION VERIFICATION */
        await levelDeployer.isLevelCompleted(level);
    });

    async function exploit() {
        /* YOUR EXPLOIT GOES HERE */
    }
});
