// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.31;

/**
 * @title BaseTaskRegistry
 * @author You
 * @notice Simple on-chain task registry for activity proof and deployment footprint
 */
contract BaseTaskRegistry {
    address public owner;
    uint256 public taskCount;

    struct Task {
        uint256 id;
        string description;
        uint256 createdAt;
    }

    mapping(uint256 => Task) public tasks;

    event TaskCreated(uint256 indexed id, string description, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createTask(string calldata _description) external onlyOwner {
        taskCount++;

        tasks[taskCount] = Task({
            id: taskCount,
            description: _description,
            createdAt: block.timestamp
        });

        emit TaskCreated(taskCount, _description, block.timestamp);
    }

    function getTask(uint256 _id) external view returns (Task memory) {
        return tasks[_id];
    }
}
