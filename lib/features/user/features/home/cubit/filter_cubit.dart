import 'package:dating_app/features/user/features/home/cubit/filter_state.dart';
import 'package:dating_app/features/user/features/home/repository/fillter_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCubit extends Cubit<FilterState> {
  final FilterRepository repository;
  FilterCubit(this.repository) : super(FilterInitial());

  Future<void> fetchLanguages() async {
    emit(FilterLoading());
    try {
      final languages = await repository.getLanguages();

      emit(
        FilterLoaded(
          availableLanguages: languages,
          selectedLanguages: ['English'],
        ),
      );
    } catch (e) {
      emit(FilterError(e.toString()));
    }
  }

  void toggleLanguage(String language) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      final currentSelected = List<String>.from(currentState.selectedLanguages);

      if (currentSelected.contains(language)) {
        currentSelected.remove(language);
      } else {
        currentSelected.add(language);
      }

      emit(currentState.copyWith(selectedLanguages: currentSelected));
    }
  }
}
