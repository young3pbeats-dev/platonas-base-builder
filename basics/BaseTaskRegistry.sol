// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.31;

/**
 * @title BaseTaskRegistry
 * @author You
 * @notice On-chain task registry for activity proof, automation, and infra signaling on Base
 */
contract BaseTaskRegistry {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotAuthorized();
    error TaskNotFound();
    error TaskAlreadyCompleted();

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    address public owner;
    uint256 public taskCount;

    enum TaskStatus {
        Pending,
        Completed
    }

    struct Task {
        uint256 id;
        string description;
        TaskStatus status;
        uint256 createdAt;
        uint256 completedAt;
    }

    mapping(uint256 => Task) public tasks;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event TaskCreated(uint256 indexed id, string description);
    event TaskCompleted(uint256 indexed id);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotAuthorized();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() {
        owner = msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                            OWNER ACTIONS
    //////////////////////////////////////////////////////////////*/
    function createTask(string calldata description) external onlyOwner {
        unchecked {
            taskCount++;
        }

        tasks[taskCount] = Task({
            id: taskCount,
            description: description,
            status: TaskStatus.Pending,
            createdAt: block.timestamp,
            completedAt: 0
        });

        emit TaskCreated(taskCount, description);
    }

    function completeTask(uint256 id) external onlyOwner {
        Task storage task = tasks[id];
        if (task.id == 0) revert TaskNotFound();
        if (task.status == TaskStatus.Completed) revert TaskAlreadyCompleted();

        task.status = TaskStatus.Completed;
        task.completedAt = block.timestamp;

        emit TaskCompleted(id);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        address oldOwner = owner;
        owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getTask(uint256 id) external view returns (Task memory) {
        if (tasks[id].id == 0) revert TaskNotFound();
        return tasks[id];
    }
}
