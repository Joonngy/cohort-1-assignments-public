// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MiniAMM} from "../src/MiniAMM.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract MiniAMMScript is Script {
    MiniAMM public miniAMM;
    MockERC20 public token0;
    MockERC20 public token1;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("FLARE_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy mock ERC20 tokens
        MockERC20 tokenA = new MockERC20("Test USD Token", "tUSD");
        MockERC20 tokenB = new MockERC20("Test Ether Token", "tETH");
        // Deploy MiniAMM with the tokens
        MiniAMM amm = new MiniAMM(address(tokenA), address(tokenB));

        vm.stopBroadcast();
    }
}
