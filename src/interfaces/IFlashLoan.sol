// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import "../lib/PoolAddress.sol";

interface IFlashLoan {
    struct FlashParams {
        address token0;
        address token1;
        uint24 fee1;
        uint256 amount0;
        uint256 amount1;
        address dex;
    }

    struct FlashCallbackData {
        uint256 amount0;
        uint256 amount1;
        address payer;
        PoolAddress.PoolKey poolKey;
        address dex;
    }

    /// @param params The parameters necessary for flash and the callback, passed in as FlashParams
    /// @notice Calls the pools flash function with data needed in `uniswapV3FlashCallback`
    /// @dev Handles multiply flash loan depending on the length of params
    function initFlash(FlashParams[] memory params) external;
}
