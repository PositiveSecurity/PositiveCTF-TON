# PositiveCTF

A set of tasks for cracking implementations of smart-contracts with typical vulnerabilities.

## Play

Visit [positive.com](https://positive.com/ctf)

OR

Clone the repository and solve locally, a separate test is made for each problem

```sh
git clone https://github.com/PositiveSecurity/PositiveCTF-TON.git

cd PositiveCTF-TON

yarn
```

## Notes

- Deploy:

  - The `LevelDeployer` class is used for standard level deployment
  - There are 2 roles assigned
    - `player`
    - `deployer`

- Exploit:

  - Write the exploit() hack using
  - `levelDeployer.player` as the sender

- Solution verification:

  - At the end of the test, `levelDeployer.isLevelCompleted` is already called to validate the solution

## Disclaimer

All code, practices and patterns in this repository are for educational purposes only.

DO NOT USE IN PRODUCTION.
