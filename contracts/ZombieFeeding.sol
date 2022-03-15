// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./ZombieFactory.sol";

interface KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract ZombieFeeding is ZombieFactory {
    KittyInterface private kittyInterface;

    function setKittyContractAddress(address kittyContract) external onlyOwner {
        kittyInterface = KittyInterface(kittyContract);
    }

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) internal ownerForce(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie), "Chua dc an");
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint256 _zombieId, uint256 kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyInterface.getKitty(kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }

    function _triggerCooldown(Zombie memory zombie) private view {
        zombie.readyTime = block.timestamp + cooldownTime;
    }

    function _isReady(Zombie memory zomebie) internal view returns (bool) {
        return zomebie.readyTime <= block.timestamp;
    }

    modifier ownerForce(uint256 _zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender, "You are not owner.");
        _;
    }
}
