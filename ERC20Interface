pragma solidity ^0.5.1;

contract ERC20Interface{

function totalSupply() external view returns(uint);
function balanceOf(address _tokenOwner) external view returns(uint balance);
function transfer(address _to,uint _tokens) external returns(bool success);

function allowance(address _tokenOwner, address _spender) external view returns(uint remaining);
function approve(address _spender,uint _tokens) external returns(bool success);
function transferFrom(address _from,address _to,uint _tokens) external returns (bool success);

event Transfer(address indexed_from,address indexed_to,uint _tokens);
event Approve(address indexed_from,address indexed_to,uint _tokens);

}
