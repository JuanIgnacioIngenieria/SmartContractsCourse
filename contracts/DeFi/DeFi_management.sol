pragma solidity ^0.8.4;

import "./MyToken.sol";
import "./StakingToken.sol";

contract managment{

    string public name = "Staking token farm";
    address public owner;

    //Se importan aqui, no se heredan 
    MyToken public myToken;
    StakingToken public stakingToken;

    address [] public stakers;

    mapping(address => uint) public stakingBalance; //Mapping para guardar el balance de los stakers
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    //Constructor
    constructor(StakingToken _stakingToken, MyToken _myToken){
        //Desplegamos los dos tokens
        stakingToken = _stakingToken;
        myToken = _myToken;
        owner = msg.sender;
    }

    function stakeTokens(uint _amount) public{
        require(_amount > 0, "SE requiere mas de 0 tokens");

        //Transferimos Tokens a este smart contract
        myToken.transferFrom(msg.sender, address(this), _amount);

        //Actualizamos saldo de staking
        stakingBalance[msg.sender] += _amount;

        if(!hasStaked[msg.sender]){
            // Agregar a la lista de stakers si no lo esta
            stakers.push(msg.sender);
            hasStaked[msg.sender] = true;
        }

        isStaking[msg.sender] = true;

    }

    function ustakeTokens()public {
        //Ver el saldo del staker
        uint balance = stakingBalance[msg.sender];
        
        //Valorar que tenga tokens 
        require(balance > 0, "No tienes tokens para unstake");
        
        //Transferir los tokens que se unstakean de nuevo al staker
        myToken.transfer(msg.sender, balance);
        
        //Restar los tokens que se unstakean del balance del staker
        stakingBalance[msg.sender] = 0;

        //Marcar al staker como no stakeado
        isStaking[msg.sender] = false;

    }

    //Emision de recompensas
    function issueTokens() public {
        //Solo el owner puede dar recompensas
        require(msg.sender == owner, "SOlo el owner entrega recomepnsas");
        
        //Emision de tokens
        for(uint i = 0 ; i < stakers.length ; i++){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];

            if(balance > 0)
                stakingToken.transfer(recipient, balance);
        }
       
    }

}

