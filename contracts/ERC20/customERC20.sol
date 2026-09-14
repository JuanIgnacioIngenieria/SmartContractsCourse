
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "./ERC20.sol";

contract customERC20 is ERC20{

    //Creamos un constructor
    constructor() ERC20("NachoToken", "NCH"){

    }

    //Crear nuevos tokens
    function createTokens() public {
        _mint(msg.sender, 1000);
    }

}