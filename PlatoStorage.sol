// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlatoStorage {
    uint256 private value;

    event ValueUpdated(uint256 oldValue, uint256 newValue, address updatedBy);

    function setValue(uint256 newValue) public {
        uint256 old = value;
        value = newValue;
        emit ValueUpdated(old, newValue, msg.sender);
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
