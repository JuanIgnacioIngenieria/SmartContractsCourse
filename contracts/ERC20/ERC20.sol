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

    //Funcion para ver una serie de tokens reservados para una persona
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

    function transfer(address to, uint256 amount) public virtual override returns (bool){
        address owner = msg.sender; //El owner es el sender es decir quien ejecuta esta función
        _transfer(owner, to, amount); //Funcion interna

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
        _beforeTokenTransfer(from, to, amount); //Hooks que se hace antes y despues para hacer un transfer
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20 transfer amount exceeds balance");
        unchecked{
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount; 
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }


    //Funcion que permite creaccion de tokens ERC-20
    function _mint(address account, uint amount) internal virtual{
        //Se utiliza addres 0 como una direccion
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
         _afterTokenTransfer(address(0), account, amount);
    }

    ///Funcion que permite la quema de tokens y su eliminación de la circulación
    function _burn(address account, uint256 amount) internal virtual{
        require(account != address(0), "ERC20: burn to the zero address");
         
         //Se utiliza address 0 como una direccion que nunca será asignada a nadie y cuando se envian tokens allí nunca se recuperan y por tanto se queman
        _beforeTokenTransfer(address(0), account, amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");

        unchecked {
            _balances[account] = accountBalance - amount;
        }

        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }
    //Funcion que permite la aprovación
    function _approve(address owner, address spender, uint256 amount) internal virtual{
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: spender from the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual{
        uint256 currentAllowance = allowance(owner, spender);

        if (currentAllowance != type(uint256).max){
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked{
                _approve(owner, spender, amount);
            }
        }
    }

    //Hooks sin implementacion virtual, que será reemplazado en el caso de heredar este contrato ERC20 y necesitar alguna implementación
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {

    }

    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {

    }


}