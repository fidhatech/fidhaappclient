import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:dating_app/features/wallet/cubit/wallet_state.dart';
import 'package:dating_app/features/wallet/widgets/balance_display.dart';
import 'package:dating_app/features/wallet/widgets/package_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletPaymentSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment Successful! Coins added to your wallet."),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () => context.read<WalletCubit>().loadWalletData(),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    if (state is WalletLoading) {
                      return const SizedBox(
                        height: 500,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        ),
                      );
                    } else if (state is WalletError) {
                      return SizedBox(
                        height: 500,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: const TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                onPressed: () => context
                                    .read<WalletCubit>()
                                    .loadWalletData(),
                                child: const Text(
                                  'Try Again',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is WalletLoaded || state is WalletPaymentSuccess) {
                      final packages = state is WalletPaymentSuccess
                          ? (state as WalletPaymentSuccess).packages
                          : (state as WalletLoaded).packages;
                      final balance = state is WalletPaymentSuccess
                          ? (state as WalletPaymentSuccess).balance
                          : (state as WalletLoaded).balance;
                      // Find best value package (highest coins per rupee)
                      int bestValueIndex = -1;
                      if (packages.isNotEmpty) {
                        double bestRatio = 0;
                        for (int i = 0; i < packages.length; i++) {
                          final p = packages[i];
                          if (p.offerPrice > 0) {
                            final ratio = p.coins / p.offerPrice;
                            if (ratio > bestRatio) {
                              bestRatio = ratio;
                              bestValueIndex = i;
                            }
                          }
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          if (balance != null)
                            BalanceDisplay(
                              coins: balance.coins,
                              message: balance.message,
                            ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              const Text(
                                '🔥 Recharge Coins',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Choose a package',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (packages.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text(
                                  'No packages available at the moment.',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.72,
                              ),
                              itemCount: packages.length,
                              itemBuilder: (context, index) {
                                final package = packages[index];
                                return PackageCard(
                                  package: package,
                                  isBestValue: index == bestValueIndex,
                                  onTap: () {
                                    context.read<WalletCubit>().startPayment(
                                      package,
                                    );
                                  },
                                );
                              },
                            ),
                          const SizedBox(height: 40),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
