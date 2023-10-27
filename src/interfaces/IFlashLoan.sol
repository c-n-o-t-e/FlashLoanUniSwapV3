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
    }

    struct FlashCallbackData {
        uint256 amount0;
        uint256 amount1;
        address payer;
        PoolAddress.PoolKey poolKey;
    }

    function initFlash(FlashParams memory params) external;
}
