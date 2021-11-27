# DAAR Build Collective

DAAR Ethereum Solidity project

Deadline 28 November 23:59

Credits @ github.com:ghivert (all base code)

# Binôme #

Thibault ROCHE

3677376

`thibault.roche.1@etu.sorbonne-universite.fr`

Paul NGUYEN DIT SYVALA

3876651

`paul.nguyen_dit_syvala@etu.sorbonne-universite.fr`


# workspace #

gnache workspace name : daar-longbow

gnache mnemonic : width color iron acid spell churn top law virus october west over


# Cas d'utilisations #

...

# Architecture conçise du programme #

...

# Installation (1/3) #

```bash
# With HTTPS
git clone https://github.com/ghivert/build-collective.git
# Or with SSH
git clone git@github.com:ghivert/build-collective.git
```

You’ll need to install dependencies. You’ll need [`Ganache`](https://www.trufflesuite.com/ganache), [`Node.js`](https://nodejs.org/en/) and [`NPM`](https://www.npmjs.com/) or [`Yarn`](https://yarnpkg.com/). You’ll need to install [`Metamask`](https://metamask.io/) as well to communicate with your blockchain.

- `Ganache` is a local blockchain development, to iterate quickly and avoiding wasting Ether during development.
- `Node.js` is used to build the frontend and running `truffle`, which is a utility to deploy contracts.
- `NPM` or `Yarn` is a package manager, to install dependencies for your frontend development. Yarn is recommended.
- `Metamask` is a in-browser utility to interact with decentralized applications.

# Installation (2/3) #

Once everything is installed, launch `Ganache`. Create a new workspace, give it a name, and accept. You should have a local blockchain running in local. Now you can copy the mnemonic phrase Ganache generated, open Metamask, and when it asks to import a mnemonic, paste the mnemonic. Create the password of your choice and that’s fine.
Now you can connect Metamask to the blockchain. To do this, add a network by clicking on `main network` and `personalized RPC`. Here, you should be able to add a network.

![Ganache Config](public/ganache-config.png)

Once you have done it, you’re connected to the Ganache blockchain!

# Installation (3/3) : Run the frontend #

Install the dependencies.

```bash
# Yarn users
yarn
# NPM users
npm install
```

Compile the contracts.

```bash
# Yarn users
yarn contracts:migrate
# NPM users
npm run contracts:migrate
```

Create a symlink for your OS if this is not done for you.

```bash
# Windows
mklink /D src\build "..\build"

# Unix and macOS
ln -s ../build ./src/build
```

Run the frontend

```bash
# Yarn users
yarn serve
# NPM users
npm run serve
```

You’re good to go!



# Lancement du projet par script (préférable) #

# Lancement du projet manuellement (alternative) #

Lancer le software Ganache, c'est la blockchain en local
./ganache-2.5.4-linux-x86_64.AppImage

Puis ouvrir un terminal dans 'build-collective-master' :
yarn serve

Puis ouvrir dans un browser : localhost:8080

a modifier: 

### Pour faire X : ###

``

### Pour faire Y : ###

``

# Visualisation #

Pour le front-end : 

`http://localhost:ZZZZ`


# Perspectives de futur développement #
