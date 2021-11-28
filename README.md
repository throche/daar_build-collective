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



# Cas d'utilisations #

On utilise meta mask pour choisir un compte parmi les comptes de la blockchain.

On se connecte depuis `http://localhost:8080` pour accéder à un compte.

On peut s'ajouter des tokens.

On peut créer un projet.

On peut lister les projets.

On peut faire des donations de tokens à un projet et devenir un collaborateur du projet.

On peut allouer des fonds d'un projet à un collaborateur


# Fichiers modifiés depuis le code source #

le front end `daar_build-collective/build-collective-master/src/views`

le contrat `daar_build-collective/build-collective-master/contracts`

ajout des structures de données et des fonctions suivantes :

```solidity

  struct Project {
    string projectName;
    address creatorUser;
    uint256 balance;
    bool registered;
    address[] collaborators;
    uint collaboratorsNumber;
  }
  
  mapping(uint => Project) private projects;
  uint private projectCount;

  function projectsLength() public view returns (uint);
  function project(uint projectIndex) public view returns (Project memory);
  function createProject(string memory projectName) public returns (Project memory);
  function addBalanceToProject(uint256 amount, string memory projectName, address addr) public returns (bool);
  function getProjectIndex(string memory projectName) private returns (bool,uint);
  function isCollaborator(uint projectIndex, address addr) private returns (bool);
  function stringsEquals(string memory s1, string memory s2) private pure returns (bool);
  function allocateProjectBudget(uint256 amount, string memory projectName, address addr) public returns (bool);

```

# Installation #

Lire le `README.md` dans le dossier `build-collective-master`.


# Lancement du projet manuellement #

1) Lancer la blockchain en local avec le software Ganache:

```bash
./ganache-2.5.4-linux-x86_64.AppImage
```

2) Lancer le frontend depuis un terminal dans 'build-collective-master' :

```bash
republier les contrats
yarn contracts:migrate

lancer le frontend:
yarn serve
```

# Visualisation #

Pour le front-end : 

`http://localhost:8080`


# Conclusion et remarques #
