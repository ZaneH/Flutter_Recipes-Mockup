import 'package:flutter/material.dart';
import 'styles.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe.dart';
import 'recipe_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CookBookPage extends StatefulWidget {
  CookBookPage({Key key}) : super(key: key);

  @override
  _CookBookPageState createState() => _CookBookPageState();
}

class _CookBookPageState extends State<CookBookPage> {
  List<Recipe> recipes;

  @override
  initState() {
    recipes = [];

    super.initState();
  }

  _buildCard(BuildContext ctx, Recipe r, int id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            maintainState: true,
            builder: (ctx) {
              return RecipePage(r);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(4, 4),
            ),
          ],
        ),
        width: MediaQuery.of(ctx).size.width / 1.1,
        height: 440,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: "${r.image}",
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.125), BlendMode.multiply),
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(r.image),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text("${r.likes}", style: thinWhiteTextStyle),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF444444).withOpacity(0.35),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: Text(
                        "${r.name}",
                        style: cardTitleTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCookBookList() {
    Stream recipeStream = Firestore.instance
        .collection('recipes')
        .orderBy('likes', descending: true)
        .snapshots();
    return StreamBuilder(
      stream: recipeStream,
      builder: (context, snapshot) {
        if (snapshot.data == null ||
            snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 64,
            height: 64,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }

        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              (snapshot.data != null) ? snapshot.data.documents.length : 1,
          itemBuilder: (ctx, idx) {
            Recipe displRecipe =
                Recipe.fromMap(snapshot.data.documents[idx].data);

            recipes.add(displRecipe);

            if (snapshot.hasData && snapshot.data != null) {
              return Center(
                child: _buildCard(
                  ctx,
                  recipes[idx],
                  idx,
                ),
              );
            }
          },
          separatorBuilder: (_, idx) {
            return SizedBox(
              height: 30,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // stack so we can put a backdrop and content
      body: Stack(
        children: <Widget>[
          // yellow backdrop
          Container(
            height: 280,
            color: Theme.of(context).primaryColor,
          ),
          // nested scroll view for collapsable header
          NestedScrollView(
            headerSliverBuilder: (_, isInnerBoxScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: false,
                  actions: <Widget>[
                    // search icon
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: kToolbarHeight,
                          height: kToolbarHeight,
                          child: Icon(Icons.search, size: 25),
                        ),
                      ),
                    ),
                    // padding after search icon
                    SizedBox(width: 16),
                  ],
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Cook Book",
                        style: titleTextStyle,
                      ),
                    ],
                  ),
                ),
              ];
            },
            // cards
            body: _buildCookBookList(),
          ),
        ],
      ),
    );
  }
}
