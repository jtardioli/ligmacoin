// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

error BeforeAirdropStart();

contract LigmaCoin is ERC20, Ownable {

  struct AirdropConfig {
    uint128 startingSupply;
    uint64 startTime;
  }

  AirdropConfig public airdropConfig;


  constructor() ERC20("Ligma", "LGMA") {
    airdropConfig.startingSupply = 69420 ether;
    airdropConfig.startTime = 1650844800; // April 25, 2020 - 12am
  }

  function transfer(address to, uint256 amount) public virtual override returns (bool) {
    address sender = _msgSender();
    uint totalSupply =  totalSupply(); 
    uint senderBalance = balanceOf(sender);

    if(totalSupply > 42069 ether) {

    require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
    _burn(sender, 1);
    _transfer(sender, to, amount - 1);

    } else {
      _transfer(sender, to, amount);
    }

    
    return true;
  }


  function airdrop(address[] calldata addresses)
    external 
    onlyOwner 
  {
    AirdropConfig memory config = airdropConfig;
    uint _startingSupply = uint(config.startingSupply);
    uint _startTime = uint(config.startTime);

    if (block.timestamp < _startTime) revert BeforeAirdropStart();

    _mint(msg.sender, _startingSupply * 10 / 100);

    uint airdropAmount = (_startingSupply * 90 / 100) / addresses.length;
    
    for (uint256 i = 0; i < addresses.length; ++i) {
      _mint(addresses[i],  airdropAmount);
    }

  }

}
