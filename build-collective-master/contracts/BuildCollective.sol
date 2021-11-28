pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

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
    uint creatorType;   // 0 for User project, 1 for Entreprise project
    address creatorUser;
    string creatorEntreprise;
    uint256 balance;
    bool registered;
    address[] collaborators;
    uint collaboratorsNumber;
    string[] collaboratorsEntreprise;
    uint collaboratorsEntrepriseNumber;
  }

  mapping(address => User) private users;
  mapping(uint => Project) private projects;
  uint private projectCount;
  mapping(uint => Entreprise) private entreprises;
  uint private entrepriseCount;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event ProjectCreated(uint indexed projectIndex, Project indexed project);
  event EntrepriseCreated(uint indexed entrepriseIndex, Entreprise indexed entreprise);

  function user(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, 0, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }

  function projectsLength() public view returns (uint) {
    return projectCount;
  }

  function project(uint projectIndex) public view returns (Project memory) {
    return projects[projectIndex];
  }

  function createProject(string memory projectName) public returns (Project memory) {
    require(bytes(projectName).length > 0);
    projects[projectCount] = Project(projectName, 0, msg.sender, "", 0, true, new address[](1), 1, new string[](0), 0);
    projects[projectCount].collaborators[0] = msg.sender;
    emit ProjectCreated(projectCount, projects[projectCount]);
    projectCount++;
  }

  
  function addBalanceToProject(uint256 amount, string memory projectName) public returns (bool) {
    require(users[msg.sender].balance >= amount);
    bool exist;
    uint projectIndex;
    (exist,projectIndex) = getProjectIndex(projectName);
    require(exist);  // will throw an error if the projectName doesn't exist
    projects[projectIndex].balance += amount;
    users[msg.sender].balance -= amount;
    
    // if the user isn't among the collaborators, add him to the collaborators array
    if (isCollaborator(projectIndex, msg.sender) == false){
    	// copy the collaborator array in a bigger array
    	address[] memory newCollaborators = new address[](projects[projectIndex].collaboratorsNumber + 1);
    	for (uint i = 0; i < projects[projectIndex].collaboratorsNumber; i++){
    	  newCollaborators[i] = projects[projectIndex].collaborators[i];      	  
    	}
    	newCollaborators[projects[projectIndex].collaboratorsNumber] = msg.sender; // add the new collaborator at the end
    	projects[projectIndex].collaborators = newCollaborators;
    	projects[projectIndex].collaboratorsNumber++;
    }
    return true;    
  }

  // retrieve project index using project name
  function getProjectIndex(string memory projectName) private returns (bool,uint){
    for(uint i = 0; i < projectCount; i++){
      if (stringsEquals(projects[i].projectName, projectName)){
        return (true,i);
      }
    }
    return (false,0);
  }

  // search if an address is among the collaborators of a project
  function isCollaborator(uint projectIndex, address addr) private returns (bool){
    for(uint i = 0; i < projects[projectIndex].collaboratorsNumber; i++){
      if (projects[projectIndex].collaborators[i] == addr){
        return true;
      }
    }
    return false;
  }

  function stringsEquals(string memory s1, string memory s2) private pure returns (bool) {
    bytes memory b1 = bytes(s1);
    bytes memory b2 = bytes(s2);
    uint256 l1 = b1.length;
    if (l1 != b2.length) return false;
    for (uint256 i=0; i<l1; i++) {
        if (b1[i] != b2[i]) return false;
    }
    return true;
  }
  
  // function to send tokens from a project to one of the collaborators.
  // can only be done by the creator of the project.
  function allocateProjectBudget(uint256 amount, string memory projectName, address addr) public returns (bool) {
    bool exist;
    uint projectIndex;
    (exist,projectIndex) = getProjectIndex(projectName);
    require(exist);  // error if the projectName doesn't exist
    require(projects[projectIndex].balance >= amount); // error if the project doesn't have enough funds to send
    require(msg.sender == projects[projectIndex].creatorUser); // error if the function isn't called by the creator of the project
    require(isCollaborator(projectIndex, addr)); // error if the receiver isn't among the collaborators
    
    projects[projectIndex].balance -= amount;
    users[addr].balance += amount;
    return true;
  }

  // Entreprise functions

  function entreprisesLength() public view returns (uint) {
    return entrepriseCount;
  }

  function entreprise(uint entrepriseIndex) public view returns (Entreprise memory) {
    return entreprises[entrepriseIndex];
  }

  function createEntreprise(string memory entrepriseName) public returns (Entreprise memory) {
    require(bytes(entrepriseName).length > 0);
    entreprises[entrepriseCount] = Entreprise(entrepriseName, msg.sender, 0, true, new address[](1), 1);
    entreprises[entrepriseCount].members[0] = msg.sender;
    emit EntrepriseCreated(entrepriseCount, entreprises[entrepriseCount]);
    entrepriseCount++;
  }

  // retrieve entreprise index using entreprise name
  function getEntrepriseIndex(string memory entrepriseName) private returns (bool,uint){
    for(uint i = 0; i < entrepriseCount; i++){
      if (stringsEquals(entreprises[i].name, entrepriseName)){
        return (true,i);
      }
    }
    return (false,0);
  }

  // the entreprise owner can create a project using his entreprise
  function createProjectEntreprise(string memory projectName, string memory entrepriseName) public returns (Project memory) {
    require(bytes(projectName).length > 0);
    require(bytes(entrepriseName).length > 0);
    bool exist;
    uint entrepriseIndex;
    (exist,entrepriseIndex) = getEntrepriseIndex(entrepriseName); 
    require (exist); // error if the entreprise doesn't exist
    require(entreprises[entrepriseIndex].owner == msg.sender); // error if the person creating the entreprise project isn't the owner
    projects[projectCount] = Project(projectName, 1, msg.sender, entrepriseName, 0, true, new address[](0), 0, new string[](1), 1);
    projects[projectCount].collaboratorsEntreprise[0] = entrepriseName;
    emit ProjectCreated(projectCount, projects[projectCount]);
    projectCount++;
  }

  // join an existing entreprise
  function joinEntreprise(string memory entrepriseName) public returns (bool) {
    require(bytes(entrepriseName).length > 0);
    bool exist;
    uint entrepriseIndex;
    (exist,entrepriseIndex) = getEntrepriseIndex(entrepriseName); 
    require (exist); // error if the entreprise doesn't exist
    require(isMember(entrepriseIndex, msg.sender) == false); // error if the user is already a member of the entreprise 
	  // copy member array in a bigger array
    address[] memory newMembers = new address[](entreprises[entrepriseIndex].membersNumber + 1);
    for (uint i = 0; i < entreprises[entrepriseIndex].membersNumber; i++){
      newMembers[i] = entreprises[entrepriseIndex].members[i];      	  
    }
    newMembers[entreprises[entrepriseIndex].membersNumber] = msg.sender; // add the new member at the end
    entreprises[entrepriseIndex].members = newMembers;
    entreprises[entrepriseIndex].membersNumber++;

    return true;        
  }

  // search if an address is among the members of an entreprise
  function isMember(uint entrepriseIndex, address addr) private returns (bool){
    for(uint i = 0; i < entreprises[entrepriseIndex].membersNumber; i++){
      if (entreprises[entrepriseIndex].members[i] == addr){
        return true;
      }
    }
    return false;
  }

  // a member can add funds to an entreprise
  function addBalanceToEntreprise(uint256 amount, string memory entrepriseName) public returns (bool) {
    require(users[msg.sender].balance >= amount);
    bool exist;
    uint entrepriseIndex;
    (exist,entrepriseIndex) = getEntrepriseIndex(entrepriseName);
    require(exist);  // error if the entrepriseName doesn't exist
    require(isMember(entrepriseIndex, msg.sender)); // error if the sender isn't among the members of the entreprise
    entreprises[entrepriseIndex].balance += amount;
    users[msg.sender].balance -= amount;
    
    return true;    
  }
}
