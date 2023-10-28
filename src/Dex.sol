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
        address token = token1;
        address token0 = token2;
        require(
            (from == token && to == token0) || (from == token0 && to == token),
            "IT"
        );

        require(ERC20(from).balanceOf(msg.sender) >= amount, "NS");
        uint swapAmount = getSwapPrice(from, to, amount);

        SafeTransferLib.safeTransferFrom(
            ERC20(from),
            msg.sender,
            address(this),
            amount
        );

        SafeTransferLib.safeTransfer(ERC20(to), msg.sender, swapAmount);
    }

    /*
        User bal of token A = 10
        Contract bal of Token A = 100
        Contract bal of Token B = 100

        User calls swap(Token A, Token B, 10);

        10 * 100 / 100
        User get 10 of Token B
        Contract bal of Token A = 110
        Contract bal of Token B = 90

        User calls swap(Token B, Token A, 10);

        10 * 110 / 90 
        User get 12.2 of Token B
        Contract bal of Token A = 97.78
        Contract bal of Token B = 100

        User can drain pool by futher swaps

    */
    function getSwapPrice(
        address from,
        address to,
        uint amount
    ) public view returns (uint) {
        return ((amount * ERC20(to).balanceOf(address(this))) /
            ERC20(from).balanceOf(address(this)));
    }
}
