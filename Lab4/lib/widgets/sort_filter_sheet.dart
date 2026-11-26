import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/home/home_cubit.dart';
import '../theme/app_colors.dart';

// Bottom sheet cu optiunile de sortare + filtrul "doar favorite"
Future<void> showSortFilterSheet(BuildContext context) {
  final cubit = context.read<HomeCubit>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const _SortFilterSheet(),
    ),
  );
}

class _SortFilterSheet extends StatelessWidget {
  const _SortFilterSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeReady) return const SizedBox.shrink();
        final cubit = context.read<HomeCubit>();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Sort & Filter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: cubit.clearFilters,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Text('Sort by',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.textGrey)),
                ),
                for (final option in DoctorSort.values)
                  ListTile(
                    dense: true,
                    title: Text(option.label),
                    trailing: state.sort == option
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () => cubit.changeSort(option),
                  ),
                const Divider(),
                SwitchListTile(
                  dense: true,
                  activeThumbColor: AppColors.primary,
                  title: Text('Favorites only (${state.favoritesCount})'),
                  value: state.favoritesOnly,
                  onChanged: cubit.setFavoritesOnly,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
