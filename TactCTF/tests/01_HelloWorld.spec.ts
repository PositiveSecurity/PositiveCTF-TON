import { SandboxContract } from '@ton/sandbox';
import '@ton/test-utils';

import { LevelDeployer } from './LevelDeployer';
import { HelloWorld } from '../build/HelloWorld/HelloWorld_HelloWorld';

// npx blueprint test 01_HelloWorld.spec.ts
describe('HelloWorld', () => {
    let level: SandboxContract<HelloWorld>;
    let levelDeployer: LevelDeployer;

    beforeEach(async () => {
        levelDeployer = new LevelDeployer();
        await levelDeployer.init();
        level = await levelDeployer.deployLevelFromDeployer(HelloWorld);
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
