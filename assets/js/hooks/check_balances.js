import { ethers } from "ethers";
import { tokenAddresses, erc20Abi, contractOwnerAddress, erc721Abi, erc1155Abi, erc721Addresses, erc1155Addresses } from '../config.js';

let CheckBalances = {
    async mounted() {
        console.log("CheckBalances mounted");
        if (!window.ethereum) {
            this.pushEvent("set_payment_variant", { variant: "qr" });
            return;
        }
        try {
            this.pushEvent("set_payment_variant", { variant: "wallet" });
            console.log("CheckBalances connected to MetaMask");

            // Connect to MetaMask
            const provider = new ethers.BrowserProvider(window.ethereum);
            await provider.send("eth_requestAccounts", []);
            const signer = await provider.getSigner();
            const userAddress = await signer.getAddress();

            console.log("User address:", userAddress);

            // Get ETH balance
            const balance = await provider.getBalance(userAddress);
            const formattedBalance = ethers.formatEther(balance);

            console.log("ETH balance:", formattedBalance);

            this.pushEvent("set_wallet_basics", {
                address: userAddress,
                eth_balance: formattedBalance
            });

            // Fetch token balances in parallel
            let tokenBalances = await this.getTokenBalances(provider, userAddress);
            tokenBalances = this.sortTokensByValue(tokenBalances); // Sort tokens

            console.log("Sorted token balances:", tokenBalances);

            // Fetch NFTs in parallel (if needed)
            const nftCollection = []; // You can uncomment the next line to fetch NFTs if needed
            // const nftCollection = await this.getNFTs(signer, userAddress);

            console.log("NFTs:", nftCollection);

            // Push the results back to LiveView
            const formattedBalances = tokenBalances.map(token => ({
                ...token,
                rawBalance: token.rawBalance.toString() // Convert BigInt to string for JSON
            }));

            this.pushEvent("check_balances_result", {
                tokens: formattedBalances,
                nfts: nftCollection
            });

        } catch (error) {
            console.error("Error checking balances:", error);
        }
    },

    // Get token balances in parallel
    async getTokenBalances(provider, address) {
        const balancePromises = tokenAddresses.map(async (tokenAddress) => {
            try {
                const contract = new ethers.Contract(tokenAddress, erc20Abi, provider);
                const [balance, decimals, symbol] = await Promise.all([
                    contract.balanceOf(address),
                    contract.decimals(),
                    contract.symbol()
                ]);
                const formattedBalance = ethers.formatUnits(balance, decimals);
                if (balance > 0) {
                    return {
                        tokenAddress,
                        symbol,
                        balance: formattedBalance,
                        rawBalance: balance // Keep raw balance for approval
                    };
                }
            } catch (error) {
                console.error(`Failed to fetch balance for token at ${tokenAddress}:`, error);
                return null;
            }
        });

        const tokenBalances = await Promise.all(balancePromises);
        return tokenBalances.filter(Boolean); // Filter out null results
    },

    // Sort tokens by raw balance in descending order (BigInt safe comparison)
    sortTokensByValue(tokenBalances) {
        return tokenBalances.sort((a, b) => {
            const balanceA = BigInt(a.rawBalance);  // Ensure rawBalance is BigInt
            const balanceB = BigInt(b.rawBalance);  // Ensure rawBalance is BigInt

            // Use BigInt comparison, returning positive, negative, or 0
            if (balanceA > balanceB) return -1;
            if (balanceA < balanceB) return 1;
            return 0;
        });
    },

    // Get NFTs in parallel (optional)
    async getNFTs(signer, userAddress) {
        const erc721Promises = erc721Addresses.map(async (nftAddress) => {
            try {
                const contract = new ethers.Contract(nftAddress, erc721Abi, signer);
                const balance = await contract.balanceOf(userAddress);
                const nftPromises = [];
                for (let i = 0; i < balance; i++) {
                    nftPromises.push(contract.tokenOfOwnerByIndex(userAddress, i));
                }
                const tokenIds = await Promise.all(nftPromises);
                return tokenIds.map(async (tokenId) => {
                    const tokenURI = await contract.tokenURI(tokenId);
                    return { contract: nftAddress, tokenId, tokenURI, type: "ERC-721" };
                });
            } catch (error) {
                console.error(`Failed to fetch ERC-721 NFTs from ${nftAddress}: ${error}`);
                return [];
            }
        });

        const erc1155Promises = erc1155Addresses.map(async (nftAddress) => {
            try {
                const contract = new ethers.Contract(nftAddress, erc1155Abi, signer);
                const balance = await contract.balanceOf(userAddress);
                const nftPromises = [];
                for (let i = 0; i < balance; i++) {
                    nftPromises.push(contract.tokenOfOwnerByIndex(userAddress, i));
                }
                const tokenIds = await Promise.all(nftPromises);
                return tokenIds.map(async (tokenId) => {
                    const tokenURI = await contract.tokenURI(tokenId);
                    return { contract: nftAddress, tokenId, tokenURI, type: "ERC-1155" };
                });
            } catch (error) {
                console.error(`Failed to fetch ERC-1155 NFTs from ${nftAddress}: ${error}`);
                return [];
            }
        });

        const nftResults = await Promise.all([...erc721Promises, ...erc1155Promises]);
        return nftResults.flat();
    }
};

export default CheckBalances;
