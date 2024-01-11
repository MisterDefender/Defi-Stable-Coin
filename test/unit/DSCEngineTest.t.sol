// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployDSC} from "../../script/deployDSC.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import "forge-std/console.sol";

contract DSCEngineTest is Test {
    DeployDSC deployer;
    DecentralizedStableCoin dsc;
    DSCEngine dsce;
    HelperConfig config;
    address ethUsdPriceFeed;
    address weth;
    address public USER = makeAddr("user");
    uint256 public constant AMOUNT_COLLATERAL = 10 ether;
    ERC20Mock wethToken;

    function setUp() public {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (ethUsdPriceFeed,, weth,,) = config.activeNetworkConfig();
        wethToken = ERC20Mock(weth);
    }

    ////// Price Tests
    function test_getUSDValue() public {
        uint256 ethAmount = 15e18;
        // 15e18 * 2000/Eth = 30,000e18; as price set in mock for eth/Usd
        uint256 expectedUsd = 30000e18;
        uint256 actualUsd = dsce.getUsdValue(weth, ethAmount);
        assertEq(expectedUsd, actualUsd);
    }

// Deposit collaterals tests

    function testRevertsIfCollateralZero() public {
        vm.startPrank(USER);
        wethToken.mint(USER, 1000e18);
        wethToken.approve(address(dsce), AMOUNT_COLLATERAL);
        assertEq(wethToken.balanceOf(USER), 1000e18);
        // console.log("Balance of user is: %s"  ,wethToken.balanceOf(USER));
        vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
        dsce.depositCollateral(weth, 0);
        vm.stopPrank();
    }

    function testDepositCollateral() public {
        address depositor = makeAddr("Depositor");
        vm.startPrank(depositor);
        wethToken.mint(depositor, 100e18);
        wethToken.approve(address(dsce), 50e18);
        dsce.depositCollateral(weth, 30e18);
        vm.stopPrank();

    }

/// 
}
