// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

contract Web3Token is ERC721, ERC721Enumerable, ERC721Pausable {
    uint256 private _nextTokenId;
    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;
    uint256 public maxSupply = 1;

    constructor() payable ERC721("Web3Token", "Web3") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmY5rPqGTN1rZxMQg2ApiSZc7JiBNs1ryDzXPZpQhC1ibm/";
    }

    function pause() public {
        _pause();
    }

    function unpause() public {
        _unpause();
    }

    function modifyMintWindows (
        bool _publicMintOpen,
        bool _allowListMintOpen
    ) external {
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    function allowListMint() public payable {
        require( publicMintOpen, "AllowListMint is not available" );
        require( totalSupply() < maxSupply, "We sold out!" );
        require( msg.value == 0.001 ether, "Not enough funds!" );
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }
    
    function publicMint() public payable {
        require( publicMintOpen, "PublicMint is not available" );
        require( totalSupply() < maxSupply, "We sold out!" );
        require( msg.value == 0.01 ether, "Not enough funds!" );
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }
    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
