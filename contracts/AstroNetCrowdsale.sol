pragma solidity ^0.4.11;


import "../crowdsale/CappedCrowdsale.sol";
import "../crowdsale/RefundableCrowdsale.sol";
import "./AstroToken.sol";

contract AstroNetCrowdsale is CappedCrowdsale, RefundableCrowdsale {

  function AstroNetCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
    CappedCrowdsale(_cap)                                                     //cap will be set to  
    FinalizableCrowdsale()
    RefundableCrowdsale(_goal)                                                //goal will be set to 1525*1,000,000,000,000,000,000
    Crowdsale(_startTime, _endTime, _rate, _wallet)                           //rate will be set to 1378 starttime/endtime unknown
    {
    //As goal needs to be met for a successful crowdsale
    //the value needs to less or equal than a cap which is limit for accepted funds
    require(_goal <= _cap);
  }

  function createTokenContract(
    string _name,
    string _symbol,
    uint8 _decimals) internal returns (MintableToken)
    {
    return new AstroToken(_name,_symbol,_decimals);
  }

  function buyTokens(address beneficiary) public payable {
    require(beneficiary != 0x0);
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate)*getBonusPercents()/100;

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();

    return super.buyTokens(beneficiary);
  }

  function getBonusPercents() internal returns(uint8) {
    uint8 percent = 0;
    if (weiRaised<goal*1/4) {
      percent = 15;
    }else if (weiRaised<goal*2/4) {
      percent = 10;
    }else if (weiRaised<goal*3/4) {
      percent = 5;
    }
    return percent;
  }
}
