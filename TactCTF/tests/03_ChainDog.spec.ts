import { SandboxContract } from '@ton/sandbox';
import '@ton/test-utils';

import { LevelDeployer } from './LevelDeployer';
import { ChainDog } from '../build/ChainDog/ChainDog_ChainDog';

// npx blueprint test 03_ChainDog.spec.ts
describe('ChainDog', () => {
    let level: SandboxContract<ChainDog>;
    let levelDeployer: LevelDeployer;

    beforeEach(async () => {
        levelDeployer = new LevelDeployer();
        await levelDeployer.init();
        level = await levelDeployer.deployLevelFromDeployer(ChainDog);
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
