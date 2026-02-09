import 'package:bloc/bloc.dart';
import 'package:dating_app/features/user/features/history/cubit/history_cubit.dart';
import 'package:dating_app/features/user/features/home/bloc/home_bloc.dart';
import 'package:dating_app/features/user/features/premium/bloc/premium_bloc.dart';

class NavigatorCubit extends Cubit<int> {
  HomeBloc homeBloc;
  PremiumBloc premiumBloc;
  HistoryCubit historyCubit;

  NavigatorCubit({
    required this.homeBloc,
    required this.historyCubit,
    required this.premiumBloc,
  }) : super(0);
  void changePage(int index) {
    if (state == index) return;
    emit(index);

    if (index == 1) {
      premiumBloc.add(FetchPremiumEvent());
    }
    if (index == 2) {
      historyCubit.fetch();
    }
  }

  void reset() {
    emit(0);
  }
}
