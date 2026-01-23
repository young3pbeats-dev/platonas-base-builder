// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

/*
    MultiFeedOracle
    Minimal on-chain multi-asset oracle for Base Mainnet.

    - Manual price updates by authorized oracle
    - Multiple asset support via bytes32 assetId
    - Freshness check
    - Zero external dependencies
*/

contract MultiFeedOracle {
    /// @notice Authorized oracle address
    address public oracle;

    /// @notice Maximum allowed delay for price freshness
    uint256 public maxDelay;

    struct PriceData {
        uint256 price;
        uint256 lastUpdated;
    }

    /// @dev assetId => PriceData
    mapping(bytes32 => PriceData) private prices;

    event PriceUpdated(bytes32 indexed assetId, uint256 price, uint256 timestamp);
    event OracleUpdated(address oldOracle, address newOracle);
    event MaxDelayUpdated(uint256 oldDelay, uint256 newDelay);

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

    /// @notice Update price for an asset (oracle-only)
    function updatePrice(bytes32 assetId, uint256 price) external onlyOracle {
        prices[assetId] = PriceData({
            price: price,
            lastUpdated: block.timestamp
        });

        emit PriceUpdated(assetId, price, block.timestamp);
    }

    /// @notice Read latest price for an asset
    function getPrice(bytes32 assetId) external view returns (uint256) {
        return prices[assetId].price;
    }

    /// @notice Check if price is still fresh
    function isPriceFresh(bytes32 assetId) external view returns (bool) {
        uint256 ts = prices[assetId].lastUpdated;
        if (ts == 0) return false;
        return block.timestamp - ts <= maxDelay;
    }

    /// @notice Update oracle address
    function updateOracle(address newOracle) external onlyOracle {
        require(newOracle != address(0), "INVALID_ORACLE");
        address old = oracle;
        oracle = newOracle;
        emit OracleUpdated(old, newOracle);
    }

    /// @notice Update freshness delay
    function updateMaxDelay(uint256 newDelay) external onlyOracle {
        require(newDelay > 0, "INVALID_DELAY");
        uint256 old = maxDelay;
        maxDelay = newDelay;
        emit MaxDelayUpdated(old, newDelay);
    }
}
