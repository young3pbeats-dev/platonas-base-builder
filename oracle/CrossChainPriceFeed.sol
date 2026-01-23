// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    CrossChainPriceFeed.sol
    Base Builder Portfolio – Oracle / Cross-chain prototype

    This contract simulates a cross-chain price feed receiver.
    In a real scenario, prices would be delivered by:
    - CCIP
    - LayerZero
    - Wormhole
    - Custom relayer / oracle

    Here we focus on:
    - Secure price updates
    - Access control
    - Clean read interface
*/

contract CrossChainPriceFeed {
    /// @notice Address allowed to push price updates (oracle / relayer)
    address public oracle;

    /// @notice Price data structure
    struct PriceData {
        uint256 price;
        uint256 timestamp;
        uint256 sourceChainId;
    }

    /// @notice Mapping asset symbol => price data
    mapping(string => PriceData) private prices;

    /// @notice Events
    event OracleUpdated(address indexed oldOracle, address indexed newOracle);
    event PriceUpdated(
        string indexed symbol,
        uint256 price,
        uint256 timestamp,
        uint256 sourceChainId
    );

    /// @notice Modifier to restrict oracle-only functions
    modifier onlyOracle() {
        require(msg.sender == oracle, "Not authorized oracle");
        _;
    }

    /// @notice Constructor sets initial oracle
    constructor(address _oracle) {
        require(_oracle != address(0), "Invalid oracle address");
        oracle = _oracle;
    }

    /// @notice Update oracle address
    function setOracle(address _newOracle) external onlyOracle {
        require(_newOracle != address(0), "Invalid oracle address");
        address oldOracle = oracle;
        oracle = _newOracle;
        emit OracleUpdated(oldOracle, _newOracle);
    }

    /// @notice Push price data (simulating cross-chain delivery)
    /// @param symbol Asset symbol (e.g. "ETH/USD")
    /// @param price Asset price
    /// @param sourceChainId Chain ID where price originated
    function updatePrice(
        string calldata symbol,
        uint256 price,
        uint256 sourceChainId
    ) external onlyOracle {
        require(bytes(symbol).length > 0, "Invalid symbol");
        require(price > 0, "Invalid price");

        prices[symbol] = PriceData({
            price: price,
            timestamp: block.timestamp,
            sourceChainId: sourceChainId
        });

        emit PriceUpdated(symbol, price, block.timestamp, sourceChainId);
    }

    /// @notice Read latest price data for an asset
    function getPrice(string calldata symbol)
        external
        view
        returns (
            uint256 price,
            uint256 timestamp,
            uint256 sourceChainId
        )
    {
        PriceData memory data = prices[symbol];
        require(data.timestamp != 0, "Price not available");
        return (data.price, data.timestamp, data.sourceChainId);
    }
}
