// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./zombiehelper.sol";
import "./SafeMath.sol";

contract ZombieAttack is zombiehelper {
    using SafeMath for uint256;

    uint256 internal randNonce = 0;
    uint256 internal attackVictoryProbability = 50;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce = randNonce.add(1);
        uint256 result = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))
        ) % _modulus;
        return result;
    }

    function attack(uint256 _zomebieId, uint256 _targetId)
        external
        ownerForce(_zomebieId)
    {
        Zombie storage myZombie = zombies[_zomebieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint256 rand = randMod(100);
        if (rand >= attackVictoryProbability) {
            myZombie.winCount += 1;
            myZombie.level += 1;
            enemyZombie.lossCount += 1;
            feedAndMultiply(_zomebieId, enemyZombie.dna, "zombie");
        } else {
            enemyZombie.winCount += 1;
            enemyZombie.level += 1;
            myZombie.lossCount += 1;
            feedAndMultiply(_targetId, myZombie.dna, "zombie");
        }
    }
}
