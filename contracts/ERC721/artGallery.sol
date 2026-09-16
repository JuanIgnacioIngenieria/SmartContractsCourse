pragma solidity ^0.8.0;

//Importamos un smart contract de openZeppelin

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";


contract ArtToken is ERC721, Ownable{

    //Construimos un token 
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){}

    //Contador de NFTs
    uint256 counter;

    //Precio de la pieza de arte
    uint256 fee = 1 ether;

    //Estructura con las propiedades de la pieza de arte
    struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    //Estructura que almacena piezas de arte
    Art [] public art_works;

    //Declaracion del evento 
    event NewArtWork (address indexed owner, uint256 id, uint256 dna);
    
    //FUNCIONES DE AYUDA

    //Creamos un numero random basandonos en el hash entre la marca de tiempo y sender, creamos el modulo para ver cuantos terminos queremos del hash en funcion de por ejemplo la rareza
    function _createRandomNum(uint256 _mod) internal view returns (uint256){
        bytes32 hash_randomNum = keccak256(abi.encodePacked(block.timestamp,msg.sender));
        uint256 randomNum = uint256(hash_randomNum);

        return randomNum % _mod;
    }

    //Creacion de NFTs de arte
    function _createArtWork (string memory _name) internal {
        //Utilizamos la funcion anterior para generar la rareza y ADN, hacemos conversion de uint256 a uint8
        uint8 randRarity = uint8(_createRandomNum(1000));
        uint8 randDna = uint8(_createRandomNum(10**16));

        //Crea la estructura temporalmente en memoria
        Art memory newArtWork = Art(_name, counter, randDna, 1, randRarity );
        art_works.push(newArtWork);
        _safeMint(msg.sender, counter);

        emit NewArtWork(msg.sender, counter, randDna);
    }

    //Actualización del precio del token NFT
    function updateFee(uint256 _fee) external onlyOwner { //OnlyOwner heredado de Ownable, nos permite solo ejecutaresta funcion si somos el owner
        fee = _fee;
    }

    //Visualización del balance del smart contract
    function infoSmartContract() public view returns(address, uint256){
        address SC_address = address(this);
        uint256 SC_money = address(this).balance / 10**18;
        return (SC_address, SC_money);
    }

    //Funcion para obtener el array de obras de arte
    function getArtWorks() public view returns (Art[] memory){
        return art_works;
    }

    //Funcion para devolver las obras de arte de un usuario (devolvera una copia memory)
    function getOwnerArtWork(address _owner) public view returns (Art [] memory){

        //Crea un array en memoria con el tamaño de las obras de ese owner
        Art [] memory result = new Art [] (balanceOf(_owner));
        uint256 counter_owner = 0;

        for(uint256 i = 0; i < art_works.length; i++){
            if (ownerOf(i) == _owner){
                result [counter_owner] = art_works[i];
                counter_owner++;
            }
        }
        return result;
    }

    function createRandomArtWork(string memory _name) public payable {
        require(msg.value >= fee);
        _createArtWork(_name);
    }

    function withdraw() external payable onlyOwner{
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }
 
    function levelUp (uint256 _artId) public {
        require(ownerOf(_artId) == msg.sender);

        //Modifica art_works directamente ya que se ha creado una referencia de art --> art_works
        Art storage art = art_works[_artId];
        art.level++;
    }

}