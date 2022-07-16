pragma solidity ^0.8.1;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
    // OpenZeppelin help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Fantastic", "Epic", "Terrible", "Crazy", "Wild", "Terrifying", "Spooky"];
    string[] secondWords = ["Cupcake", "Pizza", "Burger", "Sandwich", "Salad", "Curry", "Chicken"];
    string[] thirdWords = ["Naruto", "Sasuke", "Hinata", "Sakura", "Gaara", "Itachi", "Madara"];


    event NewEpicNFTMinted(address sender, uint256 tokenId);

     // We need to pass the name of our NFTs token and its symbol.
    constructor() ERC721 ("SquareNFT", "SQUARE"){
        console.log("Hello There, this is my NFT contract. Woah!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        //What this is doing is it's taking two things: The actual string FIRST_WORD and a stringified version of the tokenId. I combine these two strings using abi.encodePacked and then that combined string is what I use as the source of randomness.
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }
    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        //What this is doing is it's taking two things: The actual string FIRST_WORD and a stringified version of the tokenId. I combine these two strings using abi.encodePacked and then that combined string is what I use as the source of randomness.
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % secondWords.length;
        return secondWords[rand];
    }
    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        //What this is doing is it's taking two things: The actual string FIRST_WORD and a stringified version of the tokenId. I combine these two strings using abi.encodePacked and then that combined string is what I use as the source of randomness.
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input))); //keccak256 generates hash value of given input
    }


    // A function our user will hit to get their NFT.
    function makeAnEpicNFT() public {
        //Get the current tokenId, this start at 0.
        uint256 newItemId = _tokenIds.current();

        //Randomly grab words from each of the array
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        //concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );


        console.log("\n--------------------");
        console.log(
        string(
            abi.encodePacked(
                "https://nftpreview.0xdev.codes/?code=",
                finalTokenUri
            )
        )
    );
    
        console.log("--------------------\n");

        //Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFT data
        _setTokenURI(newItemId, finalTokenUri);


        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        console.log("An NFT w/ ID %s has benn minted to %s", newItemId, msg.sender);
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
    
}