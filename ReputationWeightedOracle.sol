// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

/// @title ReputationWeightedOracle
/// @author You
/// @notice Oracle that aggregates values from trusted sources weighted by reputation
/// @dev Educational / portfolio-grade oracle contract

contract ReputationWeightedOracle {
    // --- DATA STRUCTURES ---

    struct Source {
        uint256 reputation; // weight
        bool active;
    }

    mapping(address => Source) public sources;
    address public owner;

    uint256 public lastAggregatedValue;
    uint256 public lastUpdateTimestamp;

    // --- EVENTS ---

    event SourceAdded(address indexed source, uint256 reputation);
    event SourceUpdated(address indexed source, uint256 reputation, bool active);
    event ValueSubmitted(address indexed source, uint256 value);
    event Aggregated(uint256 aggregatedValue);

    // --- MODIFIERS ---

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlySource() {
        require(sources[msg.sender].active, "Not authorized source");
        _;
    }

    // --- STORAGE FOR SUBMISSIONS ---

    mapping(address => uint256) private submittedValues;
    address[] private activeSources;

    // --- CONSTRUCTOR ---

    constructor() {
        owner = msg.sender;
    }

    // --- SOURCE MANAGEMENT ---

    function addSource(address _source, uint256 _reputation) external onlyOwner {
        require(!sources[_source].active, "Already active");
        require(_reputation > 0, "Invalid reputation");

        sources[_source] = Source({
            reputation: _reputation,
            active: true
        });

        activeSources.push(_source);

        emit SourceAdded(_source, _reputation);
    }

    function updateSource(
        address _source,
        uint256 _reputation,
        bool _active
    ) external onlyOwner {
        require(sources[_source].reputation > 0, "Source not found");

        sources[_source].reputation = _reputation;
        sources[_source].active = _active;

        emit SourceUpdated(_source, _reputation, _active);
    }

    // --- DATA SUBMISSION ---

    function submitValue(uint256 _value) external onlySource {
        submittedValues[msg.sender] = _value;
        emit ValueSubmitted(msg.sender, _value);
    }

    // --- AGGREGATION LOGIC ---

    function aggregate() external {
        uint256 weightedSum = 0;
        uint256 totalWeight = 0;

        for (uint256 i = 0; i < activeSources.length; i++) {
            address source = activeSources[i];
            Source memory s = sources[source];

            if (!s.active) continue;

            uint256 value = submittedValues[source];
            if (value == 0) continue;

            weightedSum += value * s.reputation;
            totalWeight += s.reputation;
        }

        require(totalWeight > 0, "No valid data");

        uint256 aggregatedValue = weightedSum / totalWeight;

        lastAggregatedValue = aggregatedValue;
        lastUpdateTimestamp = block.timestamp;

        emit Aggregated(aggregatedValue);
    }

    // --- VIEW HELPERS ---

    function getActiveSources() external view returns (address[] memory) {
        return activeSources;
    }

    function getSubmittedValue(address _source) external view returns (uint256) {
        return submittedValues[_source];
    }
}
