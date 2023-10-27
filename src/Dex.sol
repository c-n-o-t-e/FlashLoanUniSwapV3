// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {SafeTransferLib, ERC20} from "solmate/utils/SafeTransferLib.sol";

contract Dex {
    address public token1;
    address public token2;

    constructor(address _token1, address _token2) {
        setTokens(_token1, _token2);
    }

    function setTokens(address _token1, address _token2) public {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(address token_address, uint amount) public {
        ERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint amount) public {
        require(
            (from == token1 && to == token2) ||
                (from == token2 && to == token1),
            "Invalid tokens"
        );
        require(
            ERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );

        uint swapAmount = getSwapPrice(from, to, amount);

        SafeTransferLib.safeTransferFrom(
            ERC20(from),
            msg.sender,
            address(this),
            amount
        );

        SafeTransferLib.safeApprove(ERC20(to), address(this), swapAmount);
        SafeTransferLib.safeTransfer(ERC20(to), msg.sender, swapAmount);
    }

    function getSwapPrice(
        address from,
        address to,
        uint amount
    ) public view returns (uint) {
        return ((amount * ERC20(to).balanceOf(address(this))) /
            ERC20(from).balanceOf(address(this)));
    }

    function balanceOf(
        address token,
        address account
    ) public view returns (uint) {
        return ERC20(token).balanceOf(account);
    }
}
