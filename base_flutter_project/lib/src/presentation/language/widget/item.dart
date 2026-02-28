part of '../language_screen.dart';

class _LanguageItem extends StatelessWidget {
  const _LanguageItem({
    required this.context,
    required this.language,
    this.selectedValue,
  });

  final BuildContext context;
  final Language language;
  final Language? selectedValue;

  @override
  Widget build(BuildContext context) {
    final selectedLanguageCubit = context.read<ValueCubit<Language?>>();
    return GestureDetector(
      onTap: () => selectedLanguageCubit.update(language),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Palette.primary,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Image.asset(
              language.flagPath,
              width: 24,
              height: 24,
            ),
            16.hSpace,
            Expanded(
              child: Text(
                language.languageName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IgnorePointer(
              child: CustomRadio<Language?>(
                value: language,
                groupValue: selectedValue,
                onChanged: (value) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
