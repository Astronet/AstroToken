pragma solidity ^0.4.16;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }

// contract owned {
//     address public owner;

//     function owned() {
//         owner = msg.sender;
//     }

//     modifier onlyOwner {
//         require(msg.sender == owner);
//         _;
//     }

//     function transferOwnership(address newOwner) onlyOwner {
//         owner = newOwner;
//     }
// }


// contract AstroToken is owned {
//     // Public variables of the token
//     string public name;
//     string public symbol;
//     uint8 public decimals;
//     uint256 public totalSupply;

//     // This creates an array with all balances
//     mapping (address => uint256) public balanceOf;
//     mapping (address => mapping (address => uint256)) public allowance;

//     // This generates a public event on the blockchain that will notify clients
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     // This notifies clients about the amount burnt
//     event Burn(address indexed from, uint256 value);

//     /**
//      * Constrctor function
//      *
//      * Initializes contract with initial supply tokens to the creator of the contract
//      */
//     function AstroToken(
//         uint256 initialSupply,
//         string tokenName,
//         uint8 decimalUnits,
//         string tokenSymbol,
//         address centralMinter
//     ) {
//         if( centralMinter != 0 ) owner = centralMinter;
//         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
//         totalSupply = initialSupply;                        // Update total supply
//         name = tokenName;                                   // Set the name for display purposes
//         symbol = tokenSymbol;                               // Set the symbol for display purposes
//         decimals = decimalUnits;                            // Amount of decimals for display purposes
//     }

//     /**
//      * Internal transfer, only can be called by this contract
//      */
//     function _transfer(address _from, address _to, uint _value) internal {
//         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
//         require(balanceOf[_from] >= _value);                // Check if the sender has enough
//         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
//         balanceOf[_from] -= _value;                         // Subtract from the sender
//         balanceOf[_to] += _value;                           // Add the same to the recipient
//         Transfer(_from, _to, _value);
//     }

//     /**
//      * Transfer tokens
//      *
//      * Send `_value` tokens to `_to` from your account
//      *
//      * @param _to The address of the recipient
//      * @param _value the amount to send
//      */
//     function transfer(address _to, uint256 _value) {
//         _transfer(msg.sender, _to, _value);
//     }

//     /**
//      * Transfer tokens from other address
//      *
//      * Send `_value` tokens to `_to` in behalf of `_from`
//      *
//      * @param _from The address of the sender
//      * @param _to The address of the recipient
//      * @param _value the amount to send
//      */
//     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
//         require(_value <= allowance[_from][msg.sender]);     // Check allowance
//         allowance[_from][msg.sender] -= _value;
//         _transfer(_from, _to, _value);
//         return true;
//     }

//     /**
//      * Set allowance for other address
//      *
//      * Allows `_spender` to spend no more than `_value` tokens in your behalf
//      *
//      * @param _spender The address authorized to spend
//      * @param _value the max amount they can spend
//      */
//     function approve(address _spender, uint256 _value)
//         returns (bool success) {
//         allowance[msg.sender][_spender] = _value;
//         return true;
//     }

//     /**
//      * Set allowance for other address and notify
//      *
//      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
//      *
//      * @param _spender The address authorized to spend
//      * @param _value the max amount they can spend
//      * @param _extraData some extra information to send to the approved contract
//      */
//     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
//         returns (bool success) {
//         tokenRecipient spender = tokenRecipient(_spender);
//         if (approve(_spender, _value)) {
//             spender.receiveApproval(msg.sender, _value, this, _extraData);
//             return true;
//         }
//     }

//     /**
//      * Destroy tokens
//      *
//      * Remove `_value` tokens from the system irreversibly
//      *
//      * @param _value the amount of money to burn
//      */
//     function burn(uint256 _value) returns (bool success) {
//         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
//         balanceOf[msg.sender] -= _value;            // Subtract from the sender
//         totalSupply -= _value;                      // Updates totalSupply
//         Burn(msg.sender, _value);
//         return true;
//     }

//     function mintToken(address target, uint256 mintedAmount) onlyOwner {
//         if(target == 0) target = owner;
//         balanceOf[target] += mintedAmount;
//         totalSupply += mintedAmount;
//         Transfer(0, owner, mintedAmount);
//         Transfer(owner, target, mintedAmount);
//     }

// }
/////////////////////////////////////////////////////////////////////

pragma solidity ^0.4.11;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) constant returns (uint256);
    function transfer(address to, uint256 value) returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) returns (bool) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) constant returns (uint256);
    function transferFrom(address from, address to, uint256 value) returns (bool);
    function approve(address spender, uint256 value) returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) allowed;


    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amout of tokens to be transfered
     */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
        var _allowance = allowed[_from][msg.sender];

        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
        // require (_value <= _allowance);

        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) returns (bool) {

        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));

        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifing the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() {
        owner = msg.sender;
    }


    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }

}

contract MintableToken is StandardToken, Ownable {
    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    bool public mintingFinished = false;


    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    /**
    * @dev Function to mint tokens
    * @param _to The address that will recieve the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(address _to, uint256 _amount) onlyOwner returns (bool) {
        return mintInternal(_to, _amount);
    }

    /**
    * @dev Function to stop minting new tokens.
    * @return True if the operation was successful.
    */
    function finishMinting() onlyOwner returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }

    function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        return true;
    }
}

contract AstroToken is MintableToken {

    string public name;

    string public symbol;

    uint8 public decimals;

    uint256 public minFundedEthValue;

    mapping(address => uint256) public donations;

    uint256 public totalWeiFunded;

    uint256 public maxTokensToMint;

    // address where funds are collected
    address public wallet;

    // how many wei a buyer gets per token
    uint256 public rate;

    uint256 public startTime;

    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    function AstroToken(
    uint256 _rate,
    uint256 _maxTokensToMint,
    uint256 _minValue,
    uint256 _startTime,
    address _wallet,
    string _name,
    string _symbol,
    uint8 _decimals
    ) {
        require(_rate > 0);
        require(_wallet != 0x0);

        minFundedEthValue = _minValue;
        rate = _rate;
        maxTokensToMint = _maxTokensToMint;
        wallet = _wallet;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        startTime = _startTime;
    }

    function transfer(address _to, uint _value) onlyOwner returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) onlyOwner returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function () payable {
        buyTokens(msg.sender);
    }

    function buyTokens(address beneficiary) payable {
        require(beneficiary != 0x0);
        require(msg.value > 0);
        require(now > startTime);

        uint256 weiAmount = msg.value;
        uint8 bonus = getBonusPercents();

        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(rate);

        if(bonus > 0){
            tokens += tokens * bonus / 100;    // add bonus
        }

        require(totalSupply + tokens <= maxTokensToMint);

        totalWeiFunded += msg.value;
        donations[msg.sender] += msg.value;

        mintInternal(beneficiary, tokens);
        TokenPurchase(
        msg.sender,
        beneficiary,
        weiAmount,
        tokens
        );

        forwardFunds();
    }

    // send ether to the fund collection wallet
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    function getBonusPercents() internal returns(uint8){
        uint8 percents = 0;


        if(now >= 1502755200 && now <= 1503014399){    
            percents = 15;
        }else if(now >= 1503014400 && now <= 1503446399){    
            percents = 10;
        }else if(now >= 1503446400 && now <= 1504051199){    
            percents = 5;
        }

        return percents;
    }

}
/////////////////////////////////////////////////////


import "../crowdsale/CappedCrowdsale.sol";
import "../crowdsale/RefundableCrowdsale.sol";
import "../token/MintableToken.sol";

/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract SampleCrowdsaleToken is MintableToken {

  string public constant name = "Sample Crowdsale Token";
  string public constant symbol = "SCT";
  uint8 public constant decimals = 18;

}

/**
 * @title SampleCrowdsale
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 * CappedCrowdsale - sets a max boundary for raised funds
 * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract AstroNetCrowdsale is CappedCrowdsale, RefundableCrowdsale {

  function AstroNetCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
    CappedCrowdsale(_cap)
    FinalizableCrowdsale()
    RefundableCrowdsale(_goal)
    Crowdsale(_startTime, _endTime, _rate, _wallet)
  {
    //As goal needs to be met for a successful crowdsale
    //the value needs to less or equal than a cap which is limit for accepted funds
    require(_goal <= _cap);
  }

  function createTokenContract() internal returns (MintableToken) {
    return new AstroToken();
  }

}
