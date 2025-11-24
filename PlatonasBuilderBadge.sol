// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlatonasBuilderBadge {
    string public name = "Platonas Builder Badge";
    string public symbol = "PLT-BADGE";

    mapping(address => bool) public hasBadge;
    address public owner;

    event BadgeMinted(address indexed to);

    constructor() {
        owner = msg.sender;
        hasBadge[msg.sender] = true;
        emit BadgeMinted(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function mint(address to) external onlyOwner {
        require(!hasBadge[to], "Already has badge");
        hasBadge[to] = true;
        emit BadgeMinted(to);
    }

    // Soulbound: non trasferibile
    function transferFrom(address, address, uint256) public pure returns (bool) {
        revert("Soulbound: non-transferable");
    }

    function approve(address, uint256) public pure returns (bool) {
        revert("Soulbound: non-transferable");
    }
}