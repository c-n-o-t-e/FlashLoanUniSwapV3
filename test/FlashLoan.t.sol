// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Dex} from "../src/Dex.sol";
import {FlashLoan} from "../src/FlashLoan.sol";
import {IFlashLoan} from "../src/interfaces/IFlashLoan.sol";
import {Test, console2 as console} from "forge-std/Test.sol";
import {SafeTransferLib, ERC20} from "solmate/utils/SafeTransferLib.sol";

contract FlashLoanTest is Test {
    Dex public dex;
    Dex public dex1;

    Dex public dex2;
    FlashLoan public flashLoan;

    address public constant FACTORY =
        0x1F98431c8aD98523631AE4a59f267346ea31F984;

    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    address constant UNISWAP = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address constant PEPE = 0x6982508145454Ce325dDbE47a25d4ec3d2311933;

    address constant DAI_HOLDER = 0x60FaAe176336dAb62e284Fe19B885B095d29fB7F;
    address constant PEPE_HOLDER = 0xf3B0073E3a7F747C7A38B36B805247B222C302A3;
    address constant WETH_HOLDER = 0x2fEb1512183545f48f6b9C5b4EbfCaF49CfCa6F3;

    address constant UNISWAP_HOLDER =
        0x47173B170C64d16393a52e6C480b3Ad8c302ba1e;

    function setUp() public {
        dex = new Dex(DAI, UNISWAP);
        dex1 = new Dex(WETH9, UNISWAP);

        dex2 = new Dex(PEPE, UNISWAP);
        flashLoan = new FlashLoan(FACTORY, WETH9);

        vm.startPrank(UNISWAP_HOLDER);
        approveToken(UNISWAP, address(dex));

        approveToken(UNISWAP, address(dex1));
        approveToken(UNISWAP, address(dex2));

        dex.addLiquidity(UNISWAP, 100 ether);
        dex1.addLiquidity(UNISWAP, 100 ether);

        dex2.addLiquidity(UNISWAP, 100 ether);
        vm.stopPrank();

        vm.startPrank(DAI_HOLDER);
        approveToken(DAI, address(dex));

        dex.addLiquidity(DAI, 100 ether);
        vm.stopPrank();

        vm.startPrank(WETH_HOLDER);
        approveToken(WETH9, address(dex1));

        dex1.addLiquidity(WETH9, 100 ether);
        vm.stopPrank();

        vm.startPrank(PEPE_HOLDER);
        approveToken(PEPE, address(dex2));

        dex2.addLiquidity(PEPE, 100 ether);
        vm.stopPrank();
    }

    function test_Increment() public {
        IFlashLoan.FlashParams[] memory params = new IFlashLoan.FlashParams[](
            1
        );

        console.log(ERC20(DAI).balanceOf(address(this)), "1OO");

        params[0] = IFlashLoan.FlashParams({
            token0: DAI,
            token1: WETH9,
            fee1: 3000,
            amount0: 10 ether,
            amount1: 0,
            dex: address(dex)
        });

        flashLoan.initFlash(params);

        console.log(ERC20(DAI).balanceOf(address(this)), "OO");
        // console.log(dex.balanceOf(WETH9, address(dex)));
    }

    function test_Increment2() public {
        IFlashLoan.FlashParams[] memory params = new IFlashLoan.FlashParams[](
            3
        );

        console.log(ERC20(DAI).balanceOf(address(this)), "DAI0");
        console.log(ERC20(PEPE).balanceOf(address(this)), "PEPE0");
        console.log(ERC20(WETH9).balanceOf(address(this)), "WETH0");

        params[0] = IFlashLoan.FlashParams({
            token0: DAI,
            token1: WETH9,
            fee1: 3000,
            amount0: 10 ether,
            amount1: 0,
            dex: address(dex)
        });

        params[1] = IFlashLoan.FlashParams({
            token0: DAI,
            token1: WETH9,
            fee1: 3000,
            amount0: 0,
            amount1: 10 ether,
            dex: address(dex1)
        });

        params[2] = IFlashLoan.FlashParams({
            token0: PEPE,
            token1: WETH9,
            fee1: 3000,
            amount0: 10 ether,
            amount1: 0,
            dex: address(dex2)
        });

        flashLoan.initFlash(params);
        console.log(ERC20(DAI).balanceOf(address(this)), "DAI");
        console.log(ERC20(PEPE).balanceOf(address(this)), "PEPE");
        console.log(ERC20(WETH9).balanceOf(address(this)), "WETH");

        // console.log(dex.balanceOf(DAI, address(dex)));
        // console.log(dex.balanceOf(WETH9, address(dex)));
    }

    function approveToken(address contractAddr, address token) internal {
        ERC20(contractAddr).approve(token, 100 ether);
    }
}
