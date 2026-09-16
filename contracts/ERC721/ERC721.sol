// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

//Importamos un smart contract de openZeppelin

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.6/utils/Counters.sol";

contract erc721 is ERC721{
    
    //Contador de IDs de los NFTs

    using Counters for Counters.Counter;
    Counters.Counter private _tokensIds;

    //Constructor
    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol){}

    //Envio de NFTs
    function sendNFT(address _account) public {
        _tokensIds.increment();
        uint256 newItemId = _tokensIds.current();
        _safeMint(_account, newItemId);

    }
        
}

