pragma solidity ^0.8.4;

contract StakingToken{

    //VARIABLES 
    string public name = "Staking token";
    string public symbol = "STK";
    uint256 public totalSupply = 1000000000000000000000000;
    uint256 public decimals = 18;

    //EVENTOS

    //Evento transferencia de tokens
    event Transfer (address indexed _from, address _to, uint256 _value);
    
    //Evento para aprobacion de operador
    event Approval (address indexed _owner, address _spender, uint256 _value);

    //MAPPING

    //Mapper para guardar las addresses y sus balances
    mapping (address => uint256) public balanceOf;

    //Mapper para guardar una serie de addresses owners y sus correspondientes spenders y la cantidad que disponen para gastar
    mapping (address => mapping(address => uint)) public allowance;
    
    //CONSTRUCTOR

    constructor(){
        balanceOf[msg.sender] = totalSupply;    
    }

    //FUNCIONES

    //Transferencia de tokens a un usuario
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0)); //Verifica que la address de destino no sea la direccion 0
        require(balanceOf[msg.sender] >= _value); //Verifica que el balance de la address de origen sea mayor o igual a la cantidad de tokens a transferir

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    //Transferencia de tokens a un usuario especificando un emisor
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0)); 
        require(_from != address(0)); //Verifica que la address de origen no sea la direccion 0
        require(_value <= allowance[_from][msg.sender]);
        require(balanceOf[_from] >= _value); 

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    //Funcion para dar permisos a un usuario
    function approve (address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender,_spender, _value);
        return true;
    }

    


}