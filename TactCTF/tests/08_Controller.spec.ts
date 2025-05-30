import { SandboxContract } from '@ton/sandbox';
import '@ton/test-utils';

import { LevelDeployer } from './LevelDeployer';
import { Controller } from '../build/Controller/Controller_Controller';

// npx blueprint test 08_Controller.spec.ts
describe('Controller', () => {
    let level: SandboxContract<Controller>;
    let levelDeployer: LevelDeployer;

    beforeEach(async () => {
        levelDeployer = new LevelDeployer();
        await levelDeployer.init();
        level = await levelDeployer.deployLevelFromDeployer(Controller);
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
