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
          if (state is WalletError) {
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
                    } else if (state is WalletLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          if (state.balance != null)
                            BalanceDisplay(
                              coins: state.balance!.coins,
                              message: state.balance!.message,
                            ),
                          const SizedBox(height: 32),
                          const Text(
                            'Buy Coins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (state.packages.isEmpty)
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
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.packages.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final package = state.packages[index];
                                return PackageCard(
                                  package: package,
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
