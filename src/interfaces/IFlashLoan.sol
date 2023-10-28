// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

interface IFlashLoan {
    struct FlashParams {
        uint24 fee;
        address token0;
        address token1;
        uint256 amount0;
        uint256 amount1;
        address pool;
        address dex;
    }

    struct FlashCallbackData {
        uint256 amount0;
        uint256 amount1;
        address payer;
        address token0;
        address token1;
        address pool;
        address dex;
    }

    /// @param params The parameters necessary for flash and the callback, passed in as FlashParams
    /// @notice Calls the pools flash function with data needed in `uniswapV3FlashCallback`
    /// @dev Handles single flash loan depending on the length of params
    /// @dev made function payable to reduce gas
    function initFlash(FlashParams memory params) external payable;

    /// @param params The parameters necessary for flash and the callback, passed in as FlashParams
    /// @notice Calls the pools flash function with data needed in `uniswapV3FlashCallback`
    /// @dev Handles multiply flash loan depending on the length of params
    /// @dev made function payable to reduce gas
    function multipleFlash(FlashParams[] calldata params) external payable;
}
