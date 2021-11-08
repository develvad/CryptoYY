pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import './SafeMath.sol';

interface IERC20 {
    // Devuelve la cantidad de token en existencia.
    function totalSupply() external view returns(uint256);
    // Devuelve la cantidad de tokens para una direccion idncada por parametro;
    function balanceOf(address tokenOwner) external view returns(uint256);
    // Devuelve el numero de token que el spender podra gastar en nombre del propietario (owner)
    function allowance(address owner, address spender) external view returns(uint256);
    // devuelve un balor booleano co el resultado de la operacion indicada
    function transfer(address recipient, uint256 amount) external returns (bool);
    // devuelve un balor booleano con el resultado de la operacion de gasto
    function approve(address spender, uint256 amount) external returns (bool);
    // devuelve un valor boolean con el resultado de la operacion de paso de una cantidad de tokens usando el metodo allowance()
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    ////////////////
    // EVENTOS
    ///////////////
    // Evento para emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint amount);
    // Evento que se emite cuando se establece una asignacion con el metodo allowance()
    event Aproval(address indexed owner, address indexed spender, uint256 tokens);
}

contract ERC20Basic is IERC20 {
    
    // Nombre del Token (Criptomoneda)
    string public constant name = "ERC20VLADBETA";
    // Simbolo del Token
    string public constant symbol = "VLADB";
    // Cuantos decimales trabajarán las operaciones del token
    uint8 public constant decimals = 18;
    // Cantidad de tokens total
    uint256 totaySupply_;
    
    constructor(uint256 initialSupply) public {
        // Inicio de la Criptomoneda
        // Cantidad total inicial de tokens;
        totaySupply_ = initialSupply;
        // Dueño inicial del total de los tokens
        balances[msg.sender] = totaySupply_;
    }
    
    using SafeMath for uint256; // Nos aseguramos que todas las variables uint256 usen la librería SafeMath

    mapping (address => uint256)  balances;
    mapping (address => mapping(address => uint256)) allowed;
    
    event Transfer(address indexed from, address indexed to, uint amount);
    event Aproval(address indexed owner, address indexed spender, uint256 tokens);
    
    function totalSupply() public override view returns(uint256) {
        return totaySupply_;
    }
    
    // Incrementar el totalSupply
    function increaseTotalSupply(uint256 newTokensAmount) public returns(uint256) {
        totaySupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }
    
    function balanceOf(address tokenOwner) public override view returns(uint256) {
        return balances[tokenOwner];
    }
    
    function allowance(address owner, address delegate) public override view returns(uint256) {
        return allowed[owner][delegate];
    }
    
    function transfer(address recipient, uint256 numTokens) public override returns (bool) {
        require(balances[msg.sender] >= numTokens);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[recipient] = balances[recipient].add(numTokens);
        emit Transfer(msg.sender, recipient, numTokens);
        return true;
    }
    
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Aproval(msg.sender, delegate, numTokens);
        return true;
    }
    
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;        
    }   
}
