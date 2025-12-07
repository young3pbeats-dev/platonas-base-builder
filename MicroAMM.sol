// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/*
    MICRO AMM – Educational Automated Market Maker (Base Builder Portfolio)
    Purpose: Minimal, readable prototype for learning AMM mechanics (x * y = k).
*/

contract MicroAMM {
    uint256 public reserveA;
    uint256 public reserveB;

    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event SwapAforB(uint256 amountAIn, uint256 amountBOut);
    event LiquidityWithdrawn(uint256 amountA, uint256 amountB);

    // Add liquidity (1:1 ratio for educational purposes)
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "INVALID_AMOUNTS");

        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(amountA, amountB);
    }

    // Basic swap using constant product formula: x * y = k
    function swapAforB(uint256 amountAIn) external returns (uint256 amountBOut) {
        require(amountAIn > 0, "INVALID_AMOUNT");

        uint256 k = reserveA * reserveB;
        uint256 newReserveA = reserveA + amountAIn;
        uint256 newReserveB = k / newReserveA;

        amountBOut = reserveB - newReserveB;

        reserveA = newReserveA;
        reserveB = newReserveB;

        emit SwapAforB(amountAIn, amountBOut);
    }

    // Basic withdrawal function (no LP tokens — educational)
    function withdraw(uint256 amountA, uint256 amountB) external {
        require(amountA <= reserveA, "NOT_ENOUGH_A");
        require(amountB <= reserveB, "NOT_ENOUGH_B");

        reserveA -= amountA;
        reserveB -= amountB;

        emit LiquidityWithdrawn(amountA, amountB);
    }
}
