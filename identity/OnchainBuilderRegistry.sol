// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

contract OnchainProjectRegistry {

    struct Project {
        address creator;
        string name;
        string description;
        uint256 createdAt;
        uint256 reputation;
        uint256 fundsRaised;
        bool active;
    }

    uint256 public projectCount;

    mapping(uint256 => Project) public projects;
    mapping(uint256 => mapping(address => uint256)) public contributions;
    mapping(address => uint256[]) public creatorProjects;

    event ProjectCreated(uint256 indexed projectId, address creator);
    event ProjectFunded(uint256 indexed projectId, address contributor, uint256 amount);
    event ReputationGiven(uint256 indexed projectId, address from, uint256 amount);

    modifier onlyCreator(uint256 _projectId) {
        require(msg.sender == projects[_projectId].creator, "Not creator");
        _;
    }

    function createProject(
        string memory _name,
        string memory _description
    ) public {

        projectCount++;

        projects[projectCount] = Project({
            creator: msg.sender,
            name: _name,
            description: _description,
            createdAt: block.timestamp,
            reputation: 0,
            fundsRaised: 0,
            active: true
        });

        creatorProjects[msg.sender].push(projectCount);

        emit ProjectCreated(projectCount, msg.sender);
    }

 function fundProject(uint256 _projectId) public payable {
    require(projects[_projectId].active, "Project inactive");
    require(msg.value > 0, "Send ETH");

    contributions[_projectId][msg.sender] += msg.value;
    projects[_projectId].fundsRaised += msg.value;

    (bool success, ) = payable(projects[_projectId].creator).call{value: msg.value}("");
    require(success, "Transfer failed");
    }
}
