import 'package:flutter/material.dart';
import 'package:jewelry_e_commerce/ui/search/search.dart';

class SearchContainer extends StatelessWidget {
  final int goldGramPrice;
  const SearchContainer({
    Key? key,
    required this.goldGramPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const SearchScreen();
        }));
      },
      child: Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          height: 55,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.3))
              ],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search, color: Colors.black.withOpacity(0.3)),
              const SizedBox(
                width: 4,
              ),
              Text('جستجو در بین جواهرات ...',
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(color: Colors.black.withOpacity(0.3)))
            ],
          )),
    );
  }
}
