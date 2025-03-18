// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UserProjectInteraction {
    struct Interaction {
        uint256 interactionCount;
        bool hasInteracted;
    }

    mapping(address => mapping(string => Interaction)) public userInteractions;
    string[] public projects = ["LFJ", "DUSTED", "KURU", "KIZZY", "CURVANCE", "NAD.FUN", "RAREBETSPORTS"];

    event InteractionLogged(address indexed user, string projectName);

    function logInteraction(address user, string memory projectName) public {
        require(isValidProject(projectName), "Invalid project");
        Interaction storage interaction = userInteractions[user][projectName];
        interaction.interactionCount += 1;
        interaction.hasInteracted = true;
        emit InteractionLogged(user, projectName);
    }

    function getUserInteractionCount(address user, string memory projectName) public view returns (uint256) {
        return userInteractions[user][projectName].interactionCount;
    }

    function hasUserInteracted(address user, string memory projectName) public view returns (bool) {
        return userInteractions[user][projectName].hasInteracted;
    }

    function getUserInteractions(address user) public view returns (Interaction[] memory) {
        Interaction[] memory interactions = new Interaction[](projects.length);
        for (uint256 i = 0; i < projects.length; i++) {
            interactions[i] = userInteractions[user][projects[i]];
        }
        return interactions;
    }

    function getUserInteractionForProject(address user, string memory projectName) public view returns (Interaction memory) {
        require(isValidProject(projectName), "Invalid project");
        return userInteractions[user][projectName];
    }

    function isValidProject(string memory projectName) internal view returns (bool) {
        for (uint256 i = 0; i < projects.length; i++) {
            if (keccak256(abi.encodePacked(projects[i])) == keccak256(abi.encodePacked(projectName))) {
                return true;
            }
        }
        return false;
    }
}
