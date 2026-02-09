import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/user/features/home/cubit/filter_cubit.dart';
import 'package:dating_app/features/user/features/home/cubit/filter_state.dart';
import 'package:dating_app/features/user/features/home/repository/fillter_repo.dart';
import 'package:dating_app/features/user/features/home/repository/fillter_services.dart';
import 'package:dating_app/features/user/features/home/widgets/filter_action_section.dart';
import 'package:dating_app/features/user/features/home/widgets/filter_app_bar.dart';
import 'package:dating_app/features/user/features/home/widgets/filter_section_title.dart';
import 'package:dating_app/features/user/features/home/widgets/language_chips_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FilterCubit(FilterRepository(FilterServices()))..fetchLanguages(),
      child: GradientScaffold(
        resizeToAvoidBottomInset: false,
        appBar: const FilterAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const FilterSectionTitle(title: 'Languages'),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<FilterCubit, FilterState>(
                    builder: (context, state) {
                      if (state is FilterLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FilterError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (state is FilterLoaded) {
                        return SingleChildScrollView(
                          child: LanguageChipsSelector(
                            selectedLanguages: state.selectedLanguages,
                            availableLanguages: state.availableLanguages,
                            onLanguageTap: (language) => context
                                .read<FilterCubit>()
                                .toggleLanguage(language),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const FilterActionSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
