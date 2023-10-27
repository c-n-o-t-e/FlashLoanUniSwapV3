// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {FlashLoan} from "../src/FlashLoan.sol";
import {IFlashLoan} from "../src/interfaces/IFlashLoan.sol";

contract CounterTest is Test {
    FlashLoan public flashLoan;

    address public constant FACTORY =
        0x1F98431c8aD98523631AE4a59f267346ea31F984;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    function setUp() public {
        flashLoan = new FlashLoan(FACTORY, WETH9);
    }

    function test_Increment() public {
        IFlashLoan.FlashParams memory params = IFlashLoan.FlashParams({
            token0: DAI,
            token1: WETH9,
            fee1: 3000,
            amount0: 1 ether,
            amount1: 1 ether
        });

        flashLoan.initFlash(params);
        // counter.increment();
        // assertEq(counter.number(), 1);
    }
    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
