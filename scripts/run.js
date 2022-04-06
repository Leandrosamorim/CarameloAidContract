
const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Contract addy:", waveContract.address);

  let chimkenCount = await waveContract.getTotalChimken();
  console.log(chimkenCount.toNumber());

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);

  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

    let chimkenTxn = await waveContract.shareChimken("A message!");
  
    await chimkenTxn.wait(); // Wait for the transaction to be mined
    chimkenTxn = await waveContract.shareChimken("A repeated message!");
  
    await chimkenTxn.wait(); // Wait for the transaction to be mined
    const [_, randomPerson] = await hre.ethers.getSigners();
    chimkenTxn = await waveContract.connect(randomPerson).shareChimken("Another message!");
    await chimkenTxn.wait(); // Wait for the transaction to be mined

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allChimken = await waveContract.getAllChimken();
  console.log(allChimken);
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