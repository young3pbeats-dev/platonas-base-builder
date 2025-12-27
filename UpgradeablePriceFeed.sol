// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

/* ================================
   OpenZeppelin Upgradeable Imports
   ================================ */
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/**
 * @title UpgradeablePriceFeed
 * @author Plato
 * @notice Simple upgradeable price feed using UUPS proxy pattern
 */
contract UpgradeablePriceFeed is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable
{
    /* ========= STORAGE ========= */

    uint256 private price;

    /* ========= EVENTS ========= */

    event PriceUpdated(uint256 oldPrice, uint256 newPrice);

    /* ========= CONSTRUCTOR ========= */

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /* ========= INITIALIZER ========= */

    function initialize(uint256 initialPrice) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        price = initialPrice;
    }

    /* ========= CORE LOGIC ========= */

    function setPrice(uint256 newPrice) external onlyOwner {
        uint256 old = price;
        price = newPrice;
        emit PriceUpdated(old, newPrice);
    }

    function getPrice() external view returns (uint256) {
        return price;
    }

    /* ========= UUPS AUTH ========= */

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}
}
