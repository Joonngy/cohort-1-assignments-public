// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IMiniAMM, IMiniAMMEvents} from "./IMiniAMM.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Add as many variables or functions as you would like
// for the implementation. The goal is to pass `forge test`.
contract MiniAMM is IMiniAMM, IMiniAMMEvents {
    uint256 public k = 0;
    uint256 public xReserve = 0;
    uint256 public yReserve = 0;

    address public tokenX;
    address public tokenY;

    // implement constructor
    constructor(address _tokenX, address _tokenY) {
        require(_tokenX != address(0), "tokenX cannot be zero address");
        require(_tokenY != address(0), "tokenY cannot be zero address");
        require(_tokenX != _tokenY, "Tokens must be different");

        if (_tokenX < _tokenY) {
            tokenX = _tokenX;
            tokenY = _tokenY;
        } else {
            tokenX = _tokenY;
            tokenY = _tokenX;
        }
    }

    // add parameters and implement function.
    // this function will determine the initial 'k'.
    function _addLiquidityFirstTime(uint256 x, uint256 y) internal {
        IERC20(tokenX).transferFrom(msg.sender, address(this), x);
        IERC20(tokenY).transferFrom(msg.sender, address(this), y);

        xReserve = x;
        yReserve = y;
        k = xReserve * yReserve;
    }

    // add parameters and implement function.
    // this function will increase the 'k'
    // because it is transferring liquidity from users to this contract.
    function _addLiquidityNotFirstTime(uint256 x, uint256 y) internal {
        IERC20(tokenX).transferFrom(msg.sender, address(this), x);
        IERC20(tokenY).transferFrom(msg.sender, address(this), y);

        xReserve += x;
        yReserve += y;
        k = xReserve * yReserve;
    }

    // complete the function
    function addLiquidity(uint256 xAmountIn, uint256 yAmountIn) external {
        require(
            xAmountIn > 0 && yAmountIn > 0,
            "Amounts must be greater than 0"
        );

        if (k == 0) {
            // add params
            _addLiquidityFirstTime(xAmountIn, yAmountIn);
        } else {
            // add params
            _addLiquidityNotFirstTime(xAmountIn, yAmountIn);
        }
        emit AddLiquidity(xReserve, yReserve);
    }

    // complete the function
    function swap(uint256 xAmountIn, uint256 yAmountIn) external {
        if (xAmountIn > 0) {
            require(yAmountIn == 0, "Can only swap one direction at a time");

            uint256 newXReserve = xReserve + xAmountIn;
            uint256 newYReserve = k / newXReserve;
            uint256 yAmountOut = yReserve - newYReserve;

            require(
                yAmountOut > 0 && yAmountOut < yReserve,
                "No liquidity in pool"
            );
            require(xReserve > xAmountIn, "Insufficient liquidity");

            IERC20(tokenX).transferFrom(msg.sender, address(this), xAmountIn);
            IERC20(tokenY).transfer(msg.sender, yAmountOut);

            xReserve = newXReserve;
            yReserve = newYReserve;

            emit Swap(xAmountIn, yAmountOut);
        } else if (yAmountIn > 0) {
            require(xAmountIn == 0, "Can only swap one direction at a time");

            uint256 newYReserve = yReserve + yAmountIn;
            uint256 newXReserve = k / newYReserve;
            uint256 xAmountOut = xReserve - newXReserve;

            require(
                xAmountOut > 0 && xAmountOut < xReserve,
                "No liquidity in pool"
            );
            require(yReserve > yAmountIn, "Insufficient liquidity");

            IERC20(tokenY).transferFrom(msg.sender, address(this), yAmountIn);
            IERC20(tokenX).transfer(msg.sender, xAmountOut);

            xReserve = newXReserve;
            yReserve = newYReserve;

            emit Swap(yAmountIn, xAmountOut);
        } else {
            require(false, "Must swap at least one token");
        }
    }
}


/*
##### flare-coston2
✅  [Success] Hash: 0xc8f9e73f09138c85eed33abf5d95da1f8d62c02f6bebe52b0ae8b2962f9c5497
Contract Address: 0x51e217a725e76d6c5d08ba7A2e2c0FD68daB7f36
Block: 21416229
Paid: 0.044337375 C2FLR (985275 gas * 45 gwei)


##### flare-coston2
✅  [Success] Hash: 0xe29906f21690c026e190564d2af7eef91d77a7ebd4db37417b85b45af7b23756
Contract Address: 0xb68410baF661ed53701e1402CDb90ce129585390
Block: 21416229
Paid: 0.046834695 C2FLR (1040771 gas * 45 gwei)


##### flare-coston2
✅  [Success] Hash: 0xc8e1f7938d7cb0ea4bf89f4e58c73578dd0a0aaa0b88fe9cf97e3fcf62556feb
Contract Address: 0x80Be20eFe03e0116B4EB3B7837B2DDFD7b3ABfbb
Block: 21416229
Paid: 0.044338455 C2FLR (985299 gas * 45 gwei)
*/