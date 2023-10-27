// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

interface IDex {
    function swap(address from, address to, uint amount) external;

    function addLiquidity(address token_address, uint amount) external;

    function balanceOf(
        address token,
        address account
    ) external view returns (uint);
}
