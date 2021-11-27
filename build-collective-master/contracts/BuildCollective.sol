pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  struct Project {
    string projectName;
    address creatorUser;
    uint256 balance;
    bool registered;
    address[] collaborators;
  }

  mapping(address => User) private users;
  mapping(uint => Project) private projects;
  uint private projectCount;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event ProjectCreated(uint indexed projectIndex, Project indexed project);

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
    projects[projectCount] = Project(projectName, msg.sender, 0, true, new address[](5));
    projects[projectCount].collaborators[0] = msg.sender;
    emit ProjectCreated(projectCount, projects[projectCount]);
    projectCount++;
  }

  function addBalanceToProject(uint256 amount, uint projectIndex, address addr) public returns (bool) {
    require(users[addr].balance >= amount);
    require(projectIndex < projectCount);
    require(isCollaborator(projectIndex, addr));
    projects[projectIndex].balance += amount;
    users[addr].balance -= amount;
    return true;
  }

  function isCollaborator(uint projectIndex, address addr) private returns (bool){
    for(uint i = 0; i < 5; i++){
      if (projects[projectIndex].collaborators[i] == addr){
        return true;
      }
    }
    return false;
  }

}
