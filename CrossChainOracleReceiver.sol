// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3.0;

/*
    CrossChainOracleReceiver
    Educational oracle receiver for Base Mainnet.
    Simulates cross-chain price updates via authorized relayer.
*/

contract CrossChainOracleReceiver {
    address public oracle;
    uint256 public price;
    uint256 public lastUpdated;

    event PriceUpdated(uint256 price, uint256 timestamp);

    constructor(address _oracle) {
        oracle = _oracle;
    }

    modifier onlyOracle() {
        require(msg.sender == oracle, "NOT_AUTHORIZED");
        _;
    }

    function updatePrice(uint256 _price) external onlyOracle {
        price = _price;
        lastUpdated = block.timestamp;

        emit PriceUpdated(_price, block.timestamp);
    }
}
