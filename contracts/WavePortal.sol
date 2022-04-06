// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalChimken;
    uint256 private seed;

    /*
     * A little magic, Google what events are in Solidity!
     */
    event NewChimken(address indexed from, uint256 timestamp, string message);

    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Chimken {
        address sharer; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    Chimken[] chimkens;

    mapping(address => uint256) public lastSharedAt;

    constructor() payable {
        console.log("I AM SMART CONTRACT. POG.");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    /*
     * You'll notice I changed the wave function a little here as well and
     * now it requires a string called _message. This is the message our user
     * sends us from the frontend!
     */
    function shareChimken(string memory _message) public {
        require(
            lastSharedAt[msg.sender] + 15 seconds < block.timestamp,
            "Wait 15min"
        );

        lastSharedAt[msg.sender] = block.timestamp;
        totalChimken += 1;
        console.log("%s shared chimken w/ message %s", msg.sender, _message);

        /*
         * This is where I actually store the wave data in the array.
         */
        chimkens.push(Chimken(msg.sender, _message, block.timestamp));

        /*
         * I added some fanciness here, Google it and try to figure out what it is!
         * Let me know what you learn in #general-chill-chat
         */
        
        
        seed = (block.difficulty + block.timestamp + seed) % 100;
        if (seed <= 10) {
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract");
        }
        emit NewChimken(msg.sender, block.timestamp, _message);
    }

    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllChimken() public view returns (Chimken[] memory) {
        return chimkens;
    }

    function getTotalChimken() public view returns (uint256) {
        // Optional: Add this line if you want to see the contract print the value!
        // We'll also print it over in run.js as well.
        console.log("We have %d total chimken!", totalChimken);
        return totalChimken;
    }
}
