/**
 *Submitted for verification at basescan.org on 2025-11-26
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlatoAllowlist {
    address public owner;

    mapping(address => bool) public isAllowed;

    event AddedToAllowlist(address indexed account);
    event RemovedFromAllowlist(address indexed account);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function add(address account) external onlyOwner {
        require(!isAllowed[account], "Already allowed");
        isAllowed[account] = true;
        emit AddedToAllowlist(account);
    }

    function remove(address account) external onlyOwner {
        require(isAllowed[account], "Not in allowlist");
        isAllowed[account] = false;
        emit RemovedFromAllowlist(account);
    }

    function check(address account) external view returns (bool) {
        return isAllowed[account];
    }
}
