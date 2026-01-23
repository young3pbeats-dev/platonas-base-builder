// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BaseHello {
    string public message;

    constructor() {
        message = "Hello Base Mainnet!";
    }

    function setMessage(string calldata newMessage) external {
        message = newMessage;
    }
}
