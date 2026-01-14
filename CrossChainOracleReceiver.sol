// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3.0;

/*
    CrossChainOracleReceiver
    Educational oracle receiver for Base Mainnet.

    Simulates cross-chain price updates via an authorized oracle / relayer.
    Designed as a clean, minimal oracle primitive for portfolio and learning purposes.
*/

contract CrossChainOracleReceiver {
    /// @notice Authorized oracle / relayer address
    address public oracle;

    /// @notice Latest reported price
    uint256 public price;

    /// @notice Timestamp of the last price update
    uint256 public lastUpdated;

    /// @notice Maximum allowed delay for price freshness
    uint256 public maxDelay;

    /// @notice Emitted when price is updated
    event PriceUpdated(uint256 price, uint256 timestamp);

    /// @notice Emitted when oracle address is changed
    event OracleUpdated(address oldOracle, address newOracle);

    constructor(address _oracle, uint256 _maxDelay) {
        require(_oracle != address(0), "INVALID_ORACLE");
        require(_maxDelay > 0, "INVALID_DELAY");

        oracle = _oracle;
        maxDelay = _maxDelay;
    }

    modifier onlyOracle() {
        require(msg.sender == oracle, "NOT_AUTHORIZED");
        _;
    }

    /// @notice Update the stored price (oracle-only)
    function updatePrice(uint256 _price) external onlyOracle {
        price = _price;
        lastUpdated = block.timestamp;

        emit PriceUpdated(_price, block.timestamp);
    }

    /// @notice Returns true if the stored price is still fresh
    function isPriceFresh() external view returns (bool) {
        if (lastUpdated == 0) return false;
        return block.timestamp - lastUpdated <= maxDelay;
    }

    /// @notice Update the oracle / relayer address
    function updateOracle(address newOracle) external onlyOracle {
        require(newOracle != address(0), "INVALID_ORACLE");

        address oldOracle = oracle;
        oracle = newOracle;

        emit OracleUpdated(oldOracle, newOracle);
    }

    /// @notice Update the maximum allowed delay for price freshness
    function updateMaxDelay(uint256 newMaxDelay) external onlyOracle {
        require(newMaxDelay > 0, "INVALID_DELAY");
        maxDelay = newMaxDelay;
    }
}
