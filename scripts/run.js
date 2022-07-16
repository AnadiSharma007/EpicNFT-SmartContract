const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT'); //This will actually compile our contract and generate the necessary files we need to work with our contract under the artifacts directory.
    const nftContract = await nftContractFactory.deploy(); //Create a local Ethereum network
    await nftContract.deployed(); //We'll wait until our contract is officially mined and deployed to our local blockchain! 
    console.log("Contract deployed", nftContract.address); //nftContract.address will basically give us the address of the deployed contract.
    
    // Call the function 
    let txn = await nftContract.makeAnEpicNFT()
    // wait for it to be mined
    await txn.wait()
    
    // Mint another NFT for fun
    txn = await nftContract.makeAnEpicNFT()
    // wait for it to be mined
    await txn.wait()
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
        
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();