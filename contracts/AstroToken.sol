pragma solidity ^0.4.11;

import "../token/MintableToken.sol";


contract AstroToken is MintableToken {

    string public name;

    string public symbol;

    uint8 public decimals;

    mapping(address => uint256) public donations;

    uint256 public totalWeiFunded;

    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    function AstroToken(
    string _name,
    string _symbol,
    uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function transfer(address _to, uint _value) onlyOwner returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) onlyOwner returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }
}
