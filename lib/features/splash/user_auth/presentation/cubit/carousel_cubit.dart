import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselState {
  final int currentPage;
  final int totalPages;

  const CarouselState({required this.currentPage, required this.totalPages});

  CarouselState copyWith({int? currentPage, int? totalPages}) {
    return CarouselState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class CarouselCubit extends Cubit<CarouselState> {
  CarouselCubit({required int totalPages})
    : super(CarouselState(currentPage: 0, totalPages: totalPages));

  void onPageChanged(int index) {
    emit(state.copyWith(currentPage: index));
  }

  void reset() {
    emit(state.copyWith(currentPage: 0));
  }
}
