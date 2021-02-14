pragma solidity ^0.4.18;
// written for Solidity version 0.4.18 and above that doesnt break functionality

contract Voting {
    // an event that is called whenever a StrategicDecision is added so the frontend could
    // appropriately display the StrategicDecision with the right element id (it is used
    // to vote for the StrategicDecision, since it is one of arguments for the function "vote")
    event AddedStrategicDecision(uint StrategicDecisionID);

    // describes a Voter, which has an id and the ID of the StrategicDecision they voted for
    address owner;
    function Voting()public {
        owner=msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    struct Voter {
        bytes32 uid; // bytes32 type are basically strings
        uint numberofVotingShares;
        uint StrategicDecisionIDVote;
    }
    // describes a StrategicDecision
    struct StrategicDecision {
        bytes32 name;
        bytes32 Category; 
        // "bool doesExist" is to check if this Struct exists
        // This is so we can keep track of the StrategicDecisions 
        bool doesExist; 
    }

    // These state variables are used keep track of the number of StrategicDecisions/Voters 
    // and used to as a way to index them     
    uint numStrategicDecisions; // declares a state variable - number Of StrategicDecisions
    uint numVoters;

    
    // Think of these as a hash table, with the key as a uint and value of 
    // the struct StrategicDecision/Voter. These mappings will be used in the majority
    // of our transactions/calls
    // These mappings will hold all the StrategicDecisions and Voters respectively
    mapping (uint => StrategicDecision) StrategicDecisions;
    mapping (uint => Voter) voters;
    
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     *  These functions perform transactions, editing the mappings *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

    function addStrategicDecision(bytes32 name, bytes32 Category) onlyOwner public {
        // StrategicDecisionID is the return variable
        uint StrategicDecisionID = numStrategicDecisions++;
        // Create new StrategicDecision Struct with name and saves it to storage.
        StrategicDecisions[StrategicDecisionID] = StrategicDecision(name,Category,true);
        AddedStrategicDecision(StrategicDecisionID);
    }

    function vote(bytes32 uid, uint StrategicDecisionID) public {
        // checks if the struct exists for that StrategicDecision
        if (StrategicDecisions[StrategicDecisionID].doesExist == true) {
            uint voterID = numVoters++; //voterID is the return variable
            voters[voterID] = Voter(uid,StrategicDecisionID);
        }
    }

    /* * * * * * * * * * * * * * * * * * * * * * * * * * 
     *  Getter Functions, marked by the key word "view" *
     * * * * * * * * * * * * * * * * * * * * * * * * * */
    

    // finds the total amount of votes for a specific StrategicDecision by looping
    // through voters 
    
    function returnnumberofVotingShares(bytes32 uid) public returns (uint) {
        return Voter[uid].numberofVotingShares
    }

    function totalVotes(uint StrategicDecisionID) view public returns (uint) {
        uint numOfVotes = 0; // we will return this
        for (uint i = 0; i < numVoters; i++) {
            // if the voter votes for this specific StrategicDecision, we increment the number
            if (voters[i].StrategicDecisionIDVote == StrategicDecisionID) {
                numOfVotes += Voter[i].numberofVotingShares;
            }
        }
        return numOfVotes; 
    }

    function getNumOfStrategicDecisions() public view returns(uint) {
        return numStrategicDecisions;
    }

    function getNumOfVoters() public view returns(uint) {
        return numVoters;
    }
    // returns StrategicDecision information, including its ID, name, and Category
    function getStrategicDecision(uint StrategicDecisionID) public view returns (uint,bytes32, bytes32) {
        return (StrategicDecisionID,StrategicDecisions[StrategicDecisionID].name,StrategicDecisions[StrategicDecisionID].Category);
    }
}

