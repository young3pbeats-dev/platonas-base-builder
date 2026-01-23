// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PriceFeedRegistry
 * @author Platonas Base Builder
 * @notice Registry for managing multiple price feeds per asset
 */
contract PriceFeedRegistry {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotOwner();
    error InvalidAddress();
    error NoPricesAvailable();

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event OwnerTransferred(address indexed oldOwner, address indexed newOwner);
    event PriceUpdated(bytes32 indexed asset, address indexed oracle, uint256 price);
    event OracleStatusUpdated(address indexed oracle, bool allowed);

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    address public owner;

    // oracle => allowed
    mapping(address => bool) public allowedOracles;

    // asset => oracle => price
    mapping(bytes32 => mapping(address => uint256)) public prices;

    // asset => list of reporting oracles
    mapping(bytes32 => address[]) internal assetOracles;

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier onlyOracle() {
        if (!allowedOracles[msg.sender]) revert NotOwner();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() {
        owner = msg.sender;
        emit OwnerTransferred(address(0), msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                            OWNER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert InvalidAddress();
        emit OwnerTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setOracle(address oracle, bool allowed) external onlyOwner {
        if (oracle == address(0)) revert InvalidAddress();
        allowedOracles[oracle] = allowed;
        emit OracleStatusUpdated(oracle, allowed);
    }

    /*//////////////////////////////////////////////////////////////
                            ORACLE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function updatePrice(bytes32 asset, uint256 price) external onlyOracle {
        if (prices[asset][msg.sender] == 0) {
            assetOracles[asset].push(msg.sender);
        }

        prices[asset][msg.sender] = price;
        emit PriceUpdated(asset, msg.sender, price);
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getMedianPrice(bytes32 asset) external view returns (uint256) {
        address[] memory oracles = assetOracles[asset];
        uint256 len = oracles.length;
        if (len == 0) revert NoPricesAvailable();

        uint256[] memory values = new uint256[](len);
        for (uint256 i = 0; i < len; i++) {
            values[i] = prices[asset][oracles[i]];
        }

        _sort(values);

        if (len % 2 == 1) {
            return values[len / 2];
        } else {
            return (values[len / 2 - 1] + values[len / 2]) / 2;
        }
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL HELPERS
    //////////////////////////////////////////////////////////////*/
    function _sort(uint256[] memory arr) internal pure {
        uint256 n = arr.length;
        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = i + 1; j < n; j++) {
                if (arr[j] < arr[i]) {
                    (arr[i], arr[j]) = (arr[j], arr[i]);
                }
            }
        }
    }
}
