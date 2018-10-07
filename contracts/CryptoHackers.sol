pragma solidity ^0.4.2;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract CryptoHackers is ERC721Token, Ownable  {

    uint dnaDigits = 20;
    uint dnaModulus = 10 ** dnaDigits;
    
    //Model a hacker
    struct Hacker {
        uint dna;
        string name;
        string gender;
        uint lvl;
        uint exp;
        uint bday;
        string[] skills;
    }
    // Store hackers
    Hacker[] public hackers; 

    // Store accounts that have created a hacker one time
    mapping (address => bool) public creaters;
    mapping (uint => address) public hackerToOwner;
    // mapping (uint => string[]) public hackerToSkills;

    string public hello = "HelloHacker";

    constructor ( string _name, string _symbol) public ERC721Token(_name, _symbol){}

    function _createHacker (string _name, string _gender, uint _randDna) {
        Hacker memory _hacker = Hacker(
            {
                dna: _randDna,
                name: _name, 
                gender: _gender, 
                lvl: 1, 
                exp: 0, 
                bday: now,
                skills: new string[](0)
            });
        
        uint _hackerId = hackers.push(_hacker) - 1;
        hackerToOwner[_hackerId] = msg.sender;
        _mint(msg.sender, _hackerId);
    }

    function _generateRandomDna(string _strValue) private view returns (uint) {
        uint _rand = keccak256(_strValue);
        return _rand % dnaModulus;
    }

    function createRandomHacker(string _name, string _gender) public {
        //user can create a hacker only one time
        // require(!creaters[msg.sender]);
        creaters[msg.sender] = true;
        uint _randDna = _generateRandomDna(_name);
        _createHacker(_name, _gender, _randDna);
    }

    function getOwnedTokens() external view returns (uint256[]) {
        return ownedTokens[msg.sender];
    }

    function learnNewSkill(uint _hackerId, string _skillName) public {
        require(hackerToOwner[_hackerId] == msg.sender);
        hackers[_hackerId].skills.push(_skillName);
        // (hackerToSkills[_hackerId]).push(_skillName); 
    }
}

//TODO: skills, function battlet() 

//CryptoHackers.deployed().then((i)=>{app=i;})
//app.createRandomHacker('itgel','male')