// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./ZombieFeeding.sol";

contract zombiehelper is ZombieFeeding {
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    function changeName(uint256 _zombieId, string calldata newName)
        external
        aboveLevel(2, _zombieId)
        ownerForce(_zombieId)
    {
        zombies[_zombieId].name = newName;
    }

    function changeDna(uint256 _zombieId, uint256 newDna)
        external
        aboveLevel(20, _zombieId)
        ownerForce(_zombieId)
    {
        zombies[_zombieId].dna = newDna;
    }

    function getZombiesByOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function withdraw() external onlyOwner {
        address payable _owner = payable(address(owner()));
        _owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint256 _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint256 _zombieId) external payable {
        require(msg.value == levelUpFee, "Fee is not enough");
        zombies[_zombieId].level += 1;
    }
}
