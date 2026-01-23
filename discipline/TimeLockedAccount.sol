// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TimeLockedAccount {
    address public owner;
    address public beneficiary;
    uint256 public unlockTime;

    event Deposited(address indexed from, uint256 amount);
    event ERC20Deposited(address indexed token, uint256 amount);
    event WithdrawnETH(address indexed to, uint256 amount);
    event WithdrawnERC20(address indexed token, address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    constructor(address _beneficiary, uint256 _unlockTime) {
        require(_beneficiary != address(0), "BAD_BENEFICIARY");
        require(_unlockTime > block.timestamp, "INVALID_TIME");
        owner = msg.sender;
        beneficiary = _beneficiary;
        unlockTime = _unlockTime;
    }

    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function depositERC20(address token, uint256 amount) external onlyOwner {
        require(amount > 0, "BAD_AMOUNT");
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "TF_FAILED");
        emit ERC20Deposited(token, amount);
    }

    function withdrawETH() external {
        require(block.timestamp >= unlockTime, "LOCKED");
        require(msg.sender == owner || msg.sender == beneficiary, "NOT_ALLOWED");

        uint256 bal = address(this).balance;
        require(bal > 0, "NO_ETH");

        (bool ok,) = payable(msg.sender).call{value: bal}("");
        require(ok, "ETH_SEND_FAIL");

        emit WithdrawnETH(msg.sender, bal);
    }

    function withdrawERC20(address token) external {
        require(block.timestamp >= unlockTime, "LOCKED");
        require(msg.sender == owner || msg.sender == beneficiary, "NOT_ALLOWED");

        uint256 bal = IERC20(token).balanceOf(address(this));
        require(bal > 0, "NO_TOKENS");
        require(IERC20(token).transfer(msg.sender, bal), "T_FAILED");

        emit WithdrawnERC20(token, msg.sender, bal);
    }
}
