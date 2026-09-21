pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Este proyecto manejará 2 tipos de tokens (ERC-20 y ERC-721) 
//ERC-20 para comprar boletos 
// ERC-721 para identificarlos
contract loteria is ERC20, Ownable{

    address public nft;

    //Gestion de tokens
    constructor() ERC20("Loteria", "LOT") {
        _mint(address(this), 1000);
        nft = address(new nftERC721());
    }

    //Ganador del premio
    address public ganador;

    //Registro de un usuario
    mapping(address => address) public usuario_contract;


}

contract nftERC721 is ERC721{

    constructor() ERC721("Loteria", "STE"){}
}