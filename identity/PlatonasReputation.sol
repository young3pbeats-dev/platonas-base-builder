// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title PlatonasReputation
/// @author Plato
/// @notice Simple on-chain reputation registry for builders on Base.
/// @dev V1 is intentionally manual/curated: the owner updates scores.
///      Future versions can plug into attestations / external data.
contract PlatonasReputation {
    /// @notice Single reputation profile for a given address.
    struct Reputation {
        uint64 builderScore;      // smart contracts, verified work
        uint64 defiScore;         // on-chain DeFi interactions (manual input)
        uint64 socialScore;       // social / community contribution (manual)
        uint64 consistencyScore;  // long-term consistency / activity
        uint64 lastUpdated;       // timestamp of last profile update
    }

    /// @dev Address => reputation profile.
    mapping(address => Reputation) private _profiles;

    /// @dev Addresses allowed to update scores (owner + optional curators).
    mapping(address => bool) public isCurator;

    /// @notice Owner of the contract (main curator).
    address public owner;

    /// @notice Emitted whenever reputation is updated for a user.
    event ReputationUpdated(
        address indexed user,
        uint64 builderScore,
        uint64 defiScore,
        uint64 socialScore,
        uint64 consistencyScore,
        uint64 lastUpdated
    );

    /// @notice Emitted when a curator is added or removed.
    event CuratorUpdated(address indexed curator, bool isActive);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyCurator() {
        require(isCurator[msg.sender], "Not curator");
        _;
    }

    constructor() {
        owner = msg.sender;
        isCurator[msg.sender] = true;
        emit CuratorUpdated(msg.sender, true);
    }

    /// @notice Add or remove an address as curator.
    /// @dev Curators are allowed to set/update reputation profiles.
    function setCurator(address curator, bool active) external onlyOwner {
        isCurator[curator] = active;
        emit CuratorUpdated(curator, active);
    }

    /// @notice Manually set the reputation scores for a user.
    /// @dev V1 is curated: called only by owner/curators after off-chain review.
    function setReputation(
        address user,
        uint64 builderScore,
        uint64 defiScore,
        uint64 socialScore,
        uint64 consistencyScore
    ) external onlyCurator {
        uint64 ts = uint64(block.timestamp);

        _profiles[user] = Reputation({
            builderScore: builderScore,
            defiScore: defiScore,
            socialScore: socialScore,
            consistencyScore: consistencyScore,
            lastUpdated: ts
        });

        emit ReputationUpdated(
            user,
            builderScore,
            defiScore,
            socialScore,
            consistencyScore,
            ts
        );
    }

    /// @notice Returns the full reputation profile for a user.
    function getReputation(address user)
        external
        view
        returns (
            uint64 builderScore,
            uint64 defiScore,
            uint64 socialScore,
            uint64 consistencyScore,
            uint64 lastUpdated
        )
    {
        Reputation memory rep = _profiles[user];
        return (
            rep.builderScore,
            rep.defiScore,
            rep.socialScore,
            rep.consistencyScore,
            rep.lastUpdated
        );
    }

    /// @notice Computes a weighted total score for a user.
    /// @dev Simple weights; can be adjusted in later versions.
    function getTotalScore(address user) external view returns (uint256) {
        Reputation memory rep = _profiles[user];

        // Example weights (you can tweak these):
        // builderScore * 4 + defiScore * 3 + socialScore * 2 + consistencyScore * 3
        return
            uint256(rep.builderScore) * 4 +
            uint256(rep.defiScore) * 3 +
            uint256(rep.socialScore) * 2 +
            uint256(rep.consistencyScore) * 3;
    }

    /// @notice Convenience function: returns true if user has a non-zero profile.
    function hasProfile(address user) external view returns (bool) {
        return _profiles[user].lastUpdated != 0;
    }
}
