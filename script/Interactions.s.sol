//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {stdJson} from "../lib/forge-std/src/StdJson.sol";

contract MintBasicNft is Script {
    string public constant PUG =
        "https://ipfs.io/ipfs/QmSEDJ7zbD2QVAchf8QCEbLTCtebK713veCiz1eLZCibhE?filename=ipfs.json";

    // Wklej funkcje getDeployedContractAddress() i bytesToAddress() tutaj

    function getDeployedContractAddress() private view returns (address) {
        string memory path = string.concat(
            vm.projectRoot(),
            "/broadcast/DeployBasicNft.s.sol/",
            Strings.toString(block.chainid),
            "/run-latest.json"
        );
        string memory json = vm.readFile(path);
        bytes memory contractAddress = stdJson.parseRaw(
            json,
            ".transactions[0].contractAddress"
        );
        return (bytesToAddress(contractAddress));
    }

    function bytesToAddress(
        bytes memory bys
    ) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 32))
        }
    }

    // Koniec wklejania funkcji getDeployedContractAddress() i bytesToAddress()

    function run() external {
        // Wywołaj getDeployedContractAddress() zamiast DevOpsTools.get_most_recent_deployment()
        address mostRecentlyDeployed = getDeployedContractAddress();
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}
