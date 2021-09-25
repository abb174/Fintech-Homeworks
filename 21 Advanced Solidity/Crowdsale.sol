pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, RefundablePostDeliveryCrowdsale{

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, // rate in Puppercoins
        address payable wallet, //sale beneficiary
        PupperCoin token,
        uint goal, //goal for crowdsale
        uint cap,
        uint OpenTime,
        uint CloseTime
    )
    
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        public
        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        TimedCrowdsale(now, now + 10 minutes)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        RefundablePostDeliveryCrowdsale()
        
    {
        
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet //sale beneficiary
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 10 mins.
        uint goal = 100000 wei;
        uint cap = 100000 wei;
        
        PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, goal, cap, now, now + 10 minutes);
        token_sale_address = address(token_sale);
        
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}