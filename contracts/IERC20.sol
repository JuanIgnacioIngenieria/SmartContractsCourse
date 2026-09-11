// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IERC20{

    //Funcion para leer el suminstro total de tokens
    function totalSupply() external view returns (uint256);

    //Funcion para ver el balance de una cuenta
    function balance(address account) external view returns(uint256);

    //Funcion para transferir tokens de una cuenta a otra
    function transfer(address to, uint256 amount) external returns(bool);

    //Funcion para asignar una serie de tokens reservados para una persona
    function allowance(address owner, address spender) external view returns (uint256);

    //Funcion para asignar una serie de tokens reservados para una persona
    function approve(address spender, uint256 amount) external returns (bool);

    //Funcion que realiza lo mismo que transfer pero indicando emisor
    function transferFrom(address from, address to, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}