pragma solidity ^0.5.1;
import "browser/Udemy_ERC20.sol";

contract GreenCoin is ERC20Interface{
    string public name = "GREENCOIN";
    string public symbol ="GRC";
    uint public decimals = 0;
    
    uint public supply;
    address public founder;
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) allowed;
    
    event Transfer(address indexed_from,address indexed_to,uint _tokens);
    
    constructor()public payable{
        supply = 1000000;
        founder = msg.sender;
        balances[founder] = supply; // founder has all the tokens initially and he can transfer to other accounts.
    }
    
    function totalSupply() public view returns(uint){
        return supply;
    }
    
    function balanceOf(address _tokenOwner) public view returns(uint balance){
        return balances[_tokenOwner];
    }
    
    function transfer(address _to,uint _tokens) public   returns(bool success){
        require(balances[msg.sender]>= _tokens && _tokens > 0);
        
        balances[msg.sender] -= _tokens;
        balances[_to] += _tokens;
        
        emit Transfer(msg.sender, _to, _tokens);//log recorded on Blockchain
        return true;
    }
    
    function allowance(address _tokenOwner, address _spender) public view returns(uint remaining){
        return allowed[_tokenOwner][_spender];
    }
    function approve(address _spender,uint _tokens) public returns(bool success){
        require(balances[msg.sender] >= _tokens);
        require( _tokens > 0);
        allowed[msg.sender][_spender] = _tokens;
        
        emit Approve(msg.sender,_spender, _tokens);
        return true;
    }
    
    function transferFrom(address _from,address _to,uint _tokens) public returns (bool success){
        require(allowed[_from][_to]>= _tokens,"Not allowed");
        require(balances[_from] >= _tokens);
        
        balances[_from] -= _tokens;
        balances[_to] += _tokens;
        
        allowed[_from][_to] -= _tokens;
        return true;
    }
    
    
}
