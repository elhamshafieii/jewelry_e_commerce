import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_e_commerce/ui/sub_class/sub_class_screen.dart';
import 'package:jewelry_e_commerce/ui/widgets/empty_state.dart';
import 'package:jewelry_e_commerce/util/common.dart';
import 'package:jewelry_e_commerce/util/theme.dart';

class ClassScreen extends StatelessWidget {
  final String className;
  final List classList;
  final int goldGramPrice;

  const ClassScreen(
      {super.key,
      required this.className,
      required this.classList,
      required this.goldGramPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Container(
          margin: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withOpacity(0.2)),
          child: Row(
            children: [
              BackButton(
                color: LightThemeColors.secoundryColor.withOpacity(0.8),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'جستجو در $className',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1)
              ]),
          height: 2,
          width: MediaQuery.of(context).size.width,
        ),
        Expanded(
          child: classList.isNotEmpty
              ? GridView.builder(
                  itemCount: classList.length + 2,
                  physics: defaultScrollPhysics,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: ((context, index) {
                    if (index <= classList.length - 1) {
                      final subClassItem = classList[index];
                      return Container(
                        margin: const EdgeInsets.all(8),
                        child: ClassItemScreen(
                          subClassItems: subClassItem,
                          goldGramPrice: goldGramPrice
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }))
              : EmptyView(
                  image: Image.asset(
                    'assets/images/empty_products.jpg',
                  ),
                  message: 'هیچ محصولی در این دسته وجود ندارد',
                ),
        )
      ]),
    ));
  }
}

class ClassItemScreen extends StatelessWidget {
  final int goldGramPrice;
  final List subClassItems;
  const ClassItemScreen(
      {super.key, required this.subClassItems, required this.goldGramPrice});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SubClassScreen(
            subClassItems: subClassItems,
            goldGramPrice: goldGramPrice
          );
        }));
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: subClassItems[1]['image_url'],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            (subClassItems[0] as Map).keys.first,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
