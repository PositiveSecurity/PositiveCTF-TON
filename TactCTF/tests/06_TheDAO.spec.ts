import { SandboxContract } from '@ton/sandbox';
import '@ton/test-utils';

import { LevelDeployer } from './LevelDeployer';
import { TheDAO } from '../build/TheDAO/TheDAO_TheDAO';

// npx blueprint test 06_TheDAO.spec.ts
describe('TheDAO', () => {
    let level: SandboxContract<TheDAO>;
    let levelDeployer: LevelDeployer;

    beforeEach(async () => {
        levelDeployer = new LevelDeployer();
        await levelDeployer.init();
        level = await levelDeployer.deployLevelFromPlayer(TheDAO);
    });

    it('Eploit Level', async () => {
        /* EXPLOIT */
        await exploit();

        /* SOLUTION VERIFICATION */
        await levelDeployer.sendLevelCompleted(level);
        await levelDeployer.isLevelCompleted(level);
    });

    async function exploit() {
        /* YOUR EXPLOIT GOES HERE */
    }
});
