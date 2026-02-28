part of '../language_screen.dart';

class _BodyWidget extends StatefulWidget {
  const _BodyWidget({
    required this.isFirst,
  });

  final bool isFirst;

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  final languageList = [...Language.values];

  Language get suggestLanguage {
    final systemLanguageCode = Platform.localeName.split('_').first;
    final suggestLanguage = Language.values.firstWhere(
      (element) => element.languageCode == systemLanguageCode,
      orElse: () => Language.english,
    );
    return suggestLanguage;
  }

  @override
  void initState() {
    languageList.remove(suggestLanguage);
    languageList.insert(3, suggestLanguage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: BlocBuilder<ValueCubit<Language?>, Language?>(
            builder: (context, state) {
              return ListView.separated(
                separatorBuilder: (context, index) => 16.vSpace,
                padding: EdgeInsets.fromLTRB(16, 24, 16, 22.h),
                itemCount: languageList.length,
                itemBuilder: (BuildContext context1, int index) {
                  final Language item = languageList[index];
                  if (item == suggestLanguage && state == null) {
                    return Stack(
                      children: [
                        _LanguageItem(
                          context: context,
                          language: item,
                          selectedValue: state,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Padding(
                              padding: EdgeInsets.only(right: 30.w),
                              child: Assets.lottie.tap.lottie(),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return _LanguageItem(
                    context: context,
                    language: item,
                    selectedValue: state,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
