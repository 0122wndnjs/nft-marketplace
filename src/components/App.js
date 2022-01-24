import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json'

class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    // first up is to detect ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider();
        // modern browsers
        // if there is a provider then lets
        // lets log that its working and access the window from the doc 
        // to set Web3 to the provider
        if (provider) {
            console.log('ethereum wallet is connected')
            window.web3 = new Web3(provider)
        } else {
            // no ethereum provider
            console.log('no ethereum wallet detected')
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await window.web3.eth.getAccounts()
        this.setState({account: accounts})

        // create a constant js variable networkId which is set to blockchain network id
        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]
        if (networkData) {
            // 1. create a var abi set to the Kryptobird abi
            // 2. create a var address set to networkData address
            // 3. create a var contract which grabs a new instance of web3 eth contract
            // 4. log in the console the var contract successfully
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            console.log(contract);
        }
    }

    constructor(props) {
        super(props);
        this.state = {
            account: ''
        }
    }

    render() {
        return (
            <div>
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
                    <div className='navbar-brand col-sm-3 col-md-3 mr-0'>
                        Krypto Birdz NFTs (Non Fungile Tokens)
                    </div>
                    <ul className='navbar-nav px-3'>
                        <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className='text-white'>
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>
            </div>
        )
    }
}

export default App;