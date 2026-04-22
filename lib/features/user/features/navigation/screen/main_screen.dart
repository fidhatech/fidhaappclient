import 'package:dating_app/features/user/features/home/bloc/home_bloc.dart';
import 'package:dating_app/features/user/features/home/bloc/home_event.dart';
import 'package:dating_app/features/user/features/navigation/cubit/navigator_cubit.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/navigation/widgets/bottom_nav_bar_content.dart';
import 'package:dating_app/core/widgets/socket/socket_error_listener.dart';
import 'package:dating_app/core/services/firebase_notification_service.dart';

import 'package:dating_app/core/widgets/offer_popup_card/offer_popup_card.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/payment/service/payment_service.dart';
import 'package:dating_app/features/user/features/promotion/cubit/popup_offer_cubit.dart';
import 'package:dating_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:dating_app/features/wallet/screen/wallet_screen.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _isBuying = false;
  DateTime? _lastCallStateToastAt;

  void _showCallStateToastOnce(String message, {bool isError = false}) {
    final now = DateTime.now();
    final last = _lastCallStateToastAt;
    if (last != null && now.difference(last).inMilliseconds < 1500) {
      return;
    }
    _lastCallStateToastAt = now;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FirebaseNotificationService.checkAndRequestPermission(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final userState = context.read<UserCubit>().state;
      if (userState is UserLoaded) {
        context.read<HomeBloc>().add(ConnectSocket(userState.userModel.userId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocProvider(
          create: (context) => sl<PopupOfferCubit>()..checkAndFetchOffer(),
          child: MultiBlocListener(
            listeners: [
              BlocListener<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserLoaded) {
                    context.read<HomeBloc>().add(
                      ConnectSocket(state.userModel.userId),
                    );
                  }
                },
              ),
              BlocListener<PopupOfferCubit, PopupOfferState>(
                listener: (context, state) {
                  if (state is PopupOfferLoaded) {
                    OfferPopupCard.showFromPromotion(
                      context,
                      promotion: state.promotion,
                      onBuyNow: () async {
                        Navigator.of(context).pop();

                        setState(() {
                          _isBuying = true;
                        });

                        try {
                          final paymentService = sl<PaymentService>();

                          final order = await paymentService
                              .createOrderForPromotion(state.promotion.id);

                          paymentService.openCheckout(
                            order,
                            state.promotion.title,
                          );

                          paymentService.onPaymentSuccess = (response) {
                            paymentService.verifyPayment(response).then((
                              success,
                            ) {
                              if (!context.mounted) return;
                              if (success) {
                                context.read<NavigatorCubit>().changePage(0);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Payment Successful!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                context.read<UserCubit>().fetchUser();
                              }
                            });
                          };

                          paymentService.onPaymentError = (response) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Payment Failed: ${response.message}",
                                ),
                              ),
                            );
                          };
                        } catch (e) {
                          String message = "Something went wrong";
                          if (e is DioException) {
                            if (e.response?.statusCode == 500) {
                              message = "Server error. Please try again later.";
                            } else if (e.response?.data != null &&
                                e.response!.data is Map &&
                                e.response!.data['error'] != null) {
                              final errorData = e.response!.data['error'];
                              if (errorData is Map &&
                                  errorData['message'] != null) {
                                message = errorData['message'];
                              } else {
                                message = errorData.toString();
                              }
                            } else if (e.response?.data != null &&
                                e.response!.data is Map &&
                                e.response!.data['message'] != null) {
                              message = e.response!.data['message'];
                            }
                          }
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    sl<WalletCubit>()..loadWalletData(),
                                child: const WalletScreen(),
                              ),
                            ),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isBuying = false;
                            });
                          }
                        }
                      },
                      onSkip: () {
                        Navigator.of(context).pop();
                      },
                    );
                  }
                },
              ),
              BlocListener<ClientCallCubit, ClientCallState>(
                listener: (context, state) {
                  if (state is ClientCallEnded || state is ClientCallError) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    if (state is ClientCallError) {
                      _showCallStateToastOnce(state.message, isError: true);
                    } else {
                      _showCallStateToastOnce('Call Ended');
                    }
                  }
                },
              ),
            ],
            child: BlocBuilder<NavigatorCubit, int>(
              builder: (context, state) {
                return SocketErrorListener(
                  child: BottomNavBarContent(
                    selectedIndex: state,
                    onTabChange: (index) {
                      context.read<UserCubit>().fetchUser(showLoader: false);
                      context.read<NavigatorCubit>().changePage(index);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        if (_isBuying)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
