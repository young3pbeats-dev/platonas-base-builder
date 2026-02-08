// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.31;

/**
 * @title OracleConsumer
 * @notice Multi-source oracle consumer with quorum & freshness checks
 * @dev Designed for Base mainnet experimentation
 */
contract OracleConsumer {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotOwner();
    error NotOracle();
    error StaleData();
    error QuorumNotReached();

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    address public owner;

    uint256 public quorum;              // minimum oracle responses
    uint256 public maxDelay;            // max allowed staleness (seconds)

    struct OracleData {
        uint256 value;
        uint256 updatedAt;
    }

    mapping(address => bool) public isOracle;
    mapping(address => OracleData) public oracleData;
    address[] public oracleList;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event OracleAdded(address oracle);
    event OracleRemoved(address oracle);
    event OracleUpdated(address oracle, uint256 value);
    event AggregatedValue(uint256 value, uint256 timestamp);

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier onlyOracle() {
        if (!isOracle[msg.sender]) revert NotOracle();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(uint256 _quorum, uint256 _maxDelay) {
        owner = msg.sender;
        quorum = _quorum;
        maxDelay = _maxDelay;
    }

    /*//////////////////////////////////////////////////////////////
                            ORACLE MANAGEMENT
    //////////////////////////////////////////////////////////////*/
    function addOracle(address oracle) external onlyOwner {
        isOracle[oracle] = true;
        oracleList.push(oracle);
        emit OracleAdded(oracle);
    }

    function removeOracle(address oracle) external onlyOwner {
        isOracle[oracle] = false;
        emit OracleRemoved(oracle);
    }

    /*//////////////////////////////////////////////////////////////
                            ORACLE UPDATES
    //////////////////////////////////////////////////////////////*/
    function pushData(uint256 value) external onlyOracle {
        oracleData[msg.sender] = OracleData({
            value: value,
            updatedAt: block.timestamp
        });

        emit OracleUpdated(msg.sender, value);
    }

    /*//////////////////////////////////////////////////////////////
                        AGGREGATION LOGIC
    //////////////////////////////////////////////////////////////*/
    function getAggregatedValue() external returns (uint256) {
        uint256 validCount;
        uint256 sum;

        for (uint256 i = 0; i < oracleList.length; i++) {
            OracleData memory data = oracleData[oracleList[i]];

            if (block.timestamp - data.updatedAt <= maxDelay) {
                sum += data.value;
                validCount++;
            }
        }

        if (validCount < quorum) revert QuorumNotReached();

        uint256 avg = sum / validCount;
        emit AggregatedValue(avg, block.timestamp);
        return avg;
    }
}
