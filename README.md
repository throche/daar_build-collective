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



# Visualisation #

*(installation et lancement du projet en fin de page)*

On utilise meta mask pour choisir un compte parmi les comptes de la blockchain.

On se connecte depuis `http://localhost:8080` pour accéder à un compte.


# Cas d'utilisations #

Toutes les fonctionnalités se font via le site, à travers des cartes, chacune représentant un cas d'utilisation possible.

L'ensemble des interactions sont validées/rejetées par les contrats (solidity) sur la blockchain.


**Définition** : un `utilisateur` représente une personne qui gère son propre compte, à titre privé.

**Définition** : une `entreprise` représente une personne qui gère le compte d'une entreprise.

**Gestion des comptes privés:**

- Un utilisateur peut se connecter à son compte.
- Un utilisateur peut verser le montant qu'il souhaite sur son compte.

**Gestion des entreprises:**

- Un utilisateur peut créer une entreprise et devenir son CEO.
- Un utilisateur peut rejoindre une entreprise et devenir un membre de l'entreprise.
- Un utiliateur peut lister toutes les entreprises.

- Une entreprise peut créer un projet et en devenir le propriétaire.
- Une entreprise peut financer un projet et en devenir un collaborateur.
- Un membre de l'entreprise peut ajoute des fonds à son entreprise.

**Gestion des projets:**

- Un utilisateur/entreprise peut créer un nouveau projet avec un nom et un compte associé.
- Un utilisateur/entreprise peut financer n'importe quel projet et ainsi devenir collaborateur.
- Un utilisateur/entreprise peut afficher la liste des projets, avec leurs informations relatives.
- Un utilisateur/entreprise qui est le créateur d'un projet, peut reverser une contribution du projet aux collaborateurs.

**Gestion des bounties:**

- Un utilisateur propriétaire d'un projet peut créer des bounties avec des récompenses.
- Un utilisateur peut lister les bounties en cours avec leur descriptions.
- Un utilisateur peut résolver une bounty et gagner des tokens.

# Screenshots du site en cours d'utilisation #

![Screenshot usecase 1](https://user-images.githubusercontent.com/36344463/143784482-5d9b5b51-9927-47e0-be8f-8a9718d3aff2.png)

![Screenshot usecase 2](https://user-images.githubusercontent.com/36344463/143784497-c476edc1-4ae9-4e19-b759-3cec29b8e277.png)


# Fichiers modifiés depuis le code source #

Le front end `daar_build-collective/build-collective-master/src/views/Account.vue`

Le contrat `daar_build-collective/build-collective-master/contracts/BuildCollective.sol`

Ajout des structures de données et des fonctions suivantes :

```solidity

  struct Entreprise {
    string name;
    address owner;
    uint256 balance;
    bool registered;
    address[] members;
    uint membersNumber;
  }

  struct Project {
    string projectName;
    uint creatorType;  
    address creatorUser;
    string creatorEntreprise;
    uint256 balance;
    bool registered;
    address[] collaborators;
    uint collaboratorsNumber;
    string[] collaboratorsEntreprise;
    uint collaboratorsEntrepriseNumber;
  }

  struct Bounty {
    string description;
    uint reward;
    string solution;
    bool available;
  }

  mapping(uint => Project) private projects;
  uint private projectCount;
  
  mapping(uint => Entreprise) private entreprises;
  uint private entrepriseCount;
  
  mapping(uint => mapping(uint => Bounty)) bounties; 
  mapping(uint => uint) bountiesNumber; 

  
  function projectsLength() public view returns (uint);
  function project(uint projectIndex) public view returns (Project memory);
  function createProject(string memory projectName) public returns (Project memory);
  function addBalanceToProject(uint256 amount, string memory projectName) public returns (bool);
  function getProjectIndex(string memory projectName) private view returns (bool,uint);
  function isCollaborator(uint projectIndex, address addr) private view returns (bool);
  function stringsEquals(string memory s1, string memory s2) private pure returns (bool);
  function allocateProjectBudget(uint256 amount, string memory projectName, address addr) public returns (bool);

  function entreprisesLength() public view returns (uint);
  function entreprise(uint entrepriseIndex) public view returns (Entreprise memory);
  function createEntreprise(string memory entrepriseName) public returns (Entreprise memory);
  function getEntrepriseIndex(string memory entrepriseName) private view returns (bool,uint);
  function joinEntreprise(string memory entrepriseName) public returns (bool);
  function isMember(uint entrepriseIndex, address addr) private view returns (bool);
  function addBalanceToEntreprise(uint256 amount, string memory entrepriseName) public returns (bool);
  function createProjectEntreprise(string memory projectName, string memory entrepriseName) public returns (Project memory);
  function addBalanceToProjectUsingEntreprise(uint256 amount, string memory projectName, string memory entrepriseName) public returns (bool);
  function isCollaboratorEntreprise(uint projectIndex, string memory entrepriseName) private view returns (bool);

  function bountiesLength(string memory projectName) public view returns (uint);
  function bounty(uint bountyId, string memory projectName) public view returns (Bounty memory);
  function createBounty(string memory projectName, string memory description, uint reward) public returns (bool);
  function solveBounty(string memory projectName, uint bountyId, string memory correction) public returns (bool);

```


# Installation #

Lire le `README.md` dans le dossier `build-collective-master`.


# Lancement du projet manuellement #

Après une installation réussie:

1) Lancer la blockchain en local avec le software Ganache:

```bash
./ganache-2.5.4-linux-x86_64.AppImage
```

2) Republier les contrats puis lancer le frontend depuis un terminal dans 'build-collective-master' :

```bash
yarn contracts:migrate

yarn serve
```