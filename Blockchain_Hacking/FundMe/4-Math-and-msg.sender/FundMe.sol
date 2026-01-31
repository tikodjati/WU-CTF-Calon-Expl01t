// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";

contract FundMe{

    uint256 public minimumUSD = 5e18;
    address[] public  funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    
    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent
        // 1. How do we send ETH to this contract?

        // konsep revert

        require(getConversionRate(msg.value) >=  minimumUSD, "uang tidak cukup"); // msg.value dalam bentuk wei. 1 ETH -> 1e18 -> 1000 000 000 000 000 000 wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    } 

    function getPrice() public view returns(uint256){
        // Address -> 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 _ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountUSD = (ethPrice * _ethAmount) / 1e18;
        return ethAmountUSD;
    }

    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
