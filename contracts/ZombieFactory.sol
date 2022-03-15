// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Ownable.sol";
import "./SafeMath.sol";

contract ZombieFactory is Ownable {
    using SafeMath for uint256;

    uint256 internal dnaDigits = 16;
    uint256 internal dnaModulus = 10**dnaDigits;
    Zombie[] public zombies;
    uint256 internal cooldownTime = 1 days;
    event NewZombie(uint256 zombieId, string name, uint256 dna);
    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) public ownerZombieCount;
    uint256 levelUpFee = 0.001 ether;

    function _createZombie(string memory _name, uint256 dna) internal {
        zombies.push(
            Zombie(_name, dna, 1, block.timestamp + cooldownTime, 0, 0)
        );
        uint256 id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        emit NewZombie(id, _name, dna);
    }

    function __generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory name) public {
        require(ownerZombieCount[msg.sender] == 0, "Het quyen tao");
        uint256 randDna = __generateRandomDna(name);
        _createZombie(name, randDna);
    }

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint256 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }
}
