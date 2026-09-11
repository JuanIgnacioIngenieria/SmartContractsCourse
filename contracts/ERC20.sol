// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

//"@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IERC20{

    //Funcion para leer el suminstro total de tokens
    function totalSupply() external view returns (uint256);

    //Funcion para ver el balance de una cuenta
    function balanceOf(address account) external view returns(uint256);

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

abstract contract ERC20 is IERC20{

    //Mapeo para relacionar una persona y la cantidad de tokens de la que dispone
    mapping(address => uint256) private _balances;

    //Mapeo para relacionar un owner con un spender para permitir gasto
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;

    }  

    //Virtual (funcion que podremos reecribir mas tarde) no se usara en interfzces ya que se entiende que se usara para ser sobreescritas
    //Override (función que sobrescribe otra ya escrita anteriormente)

    function name() public view virtual returns (string memory){
        return _name;
    }

    function symbol() public view virtual returns (string memory){
        return _symbol;
    }

    //Funcion que sirve para declarar los decimales del token (Un token es divisible de ahi el uso de decimales)
    function decimals() public view virtual returns (uint8){
        return 18;
    }

    //Estas funciones son override ya que ya fueron implementadas en la interfaz y las estamos sobreescribiendo

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256){
        return _balances[account];
    }

    function transfer(address to, uint256 value) public view virtual override returns (bool){
        address owner = msg.sender; //El owner es el sender es decir quien ejecuta esta función
        _transfer(owner, to, amount); //funcion interna

        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256){
        return _allowances[owner][spender];

    }

    function approve(address spender, uint256 amount) public  virtual override returns (bool){
        address owner = msg.sender; //El owner es el sender es decir quien ejecuta esta función
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool){
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;

    }

    //Realizar mmodificacón de tokens para un spender

    function increaseAllowance(address spender, uint addedValue) public virtual returns (bool){
        address owner = msg.sender;

        //Al valor ya estipulado para el spender se le añadirá addedValue, el valor ya estipulado lo recoge el mapping
        _approve(owner, spender, _allowances[owner][spender] + addedValue); 
        return true;
    }

    function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool){
        address owner = msg.sender;
        uint256 currentAllowance = _allowances[owner][spender];
        require(currentAllowance >= subtractedValue);
        
        //Ahorramos gas innecesario con la funcion unchecked
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue); 
        }
        return true;
    }

    //Funciones internas de un token ERC-20 (_transfer, _mint, _burn) y las que se han ido declarando

    function _transfer(address from, address to, uint amount) internal virtual{
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(from, to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20 transfer amount exceeds balance");
        unchecked{
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

}