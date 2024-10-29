[authorBadge]: https://img.shields.io/badge/Author-Toni%20CANTARUTTI-blue
[authorLink]: https://github.com/toni-cantarutti?tab=repositories
[licenseBadge]: https://img.shields.io/badge/License-WTFPL-brightgreen.svg
[licenseLink]: LICENSE
[nodejs]: https://nodejs.org/en/download/package-manager
[pnpm]: https://pnpm.io/installation

[![Author][authorBadge]][authorLink]
[![License][licenseBadge]][licenseLink]

# Hardhat boilerplate

This project demonstrates a basic Hardhat use case. It comes with sample contracts, tests for those contracts, and a Hardhat Ignition module that deploys them.<br>
This repository is ready for you to clone and start building your code around it. Simply follow the guide below.

## Prerequisites

1. You need [Node.js][nodejs] installed
1. This repo was originally created with [pnpm][pnpm] but you can `npm` or `yarn`.

## Install

1. Clone the boilerplate in your current folder and delete the `.git` folder to start from scratch:

    ```bash
    git clone --depth 1 git@github.com:toni-cantarutti/hardhat-boilerplate.git . && rm -rf .git
    ```

1. Install dependencies:

      ```bash
      pnpm install
      ```

## Configuration

* You can created an `.env` in your root folder if you want to deploy your contract on a mainnet/testnet and/or using forked test blockchain

  ```bash
   INFURA_API_KEY = <your_key>
   PRIVATE_KEY = <your_key>
   ETHERSCAN_API_KEY = <your_key>
   ```

* Hardhat uses an internal blockchain that exclusively contains your deployed contracts, providing a streamlined environment for development. For advanced testing scenarios, you have the option to fork the Ethereum mainnet or a testnet. To enable forking, simply set `const ENABLE_FORKING = true;` in [hardhat.config.ts](hardhat.config.ts) file. This feature allows you to simulate real network conditions, making it easier to test interactions with existing contracts and ensure your code behaves as expected.

## Commands

### Running a local node

```bash
pnpm hardhat node
```

### Compilation

```bash
pnpm hardhat compile
```

### Deployment

* Deploy internally:

   ```bash
   pnpm hardhat ignition deploy ignition/modules/Lock.ts
   ```

* Deploy on localhost:

   ```bash
   pnpm hardhat ignition deploy ignition/modules/Lock.ts --network localhost
   ```

* Deploy on a testnet (on Holesky here):

   ```bash
   pnpm hardhat ignition deploy ignition/modules/Lock.ts --network holesky
   ```

### Verifying

   ```bash
   pnpm hardhat verify --network holesky [address]
   ```

### Console

   ```bash
   pnpm hardhat console --network localhost
   ```

### Testing

* Run tests in parallel:

   ```bash
   pnpm hardhat test --parallel
   ```

* Check coverage:

   ```bash
  pnpm hardhat coverage
   ```

## License

Under the WTFPL license. See the [LICENSE][licenseLink] file for details.
