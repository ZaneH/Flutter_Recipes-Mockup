import 'package:flutter/material.dart';
import 'recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'styles.dart';
import 'package:flutter/services.dart';

class RecipePage extends StatefulWidget {
  final Recipe displayRecipe;

  const RecipePage(this.displayRecipe);

  @override
  State<StatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>
    with SingleTickerProviderStateMixin {
  Animation<double> _fadeInAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Interval(
        0.4, 1, curve: Curves.easeInSine,
      ),
      parent: _controller,
    ));

    _controller.reset();
    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();

    super.dispose();
  }

  _buildMatList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xfff9f9f7),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: widget.displayRecipe.materials.map((mat) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                Text(mat['name']),
                Spacer(),
                Text(mat['amount']),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Hero(
            tag: "${widget.displayRecipe.image}",
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.displayRecipe.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Container(
          //   height: MediaQuery.of(context).size.height / 2.2,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.lerp(
          //         Alignment.center,
          //         Alignment.bottomCenter,
          //         0.1,
          //       ),
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Colors.transparent,
          //         Colors.white,
          //       ],
          //     ),
          //   ),
          // ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withOpacity(0.88),
                      ),
                      width: 44,
                      height: 44,
                      child: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3,
            left: 24,
            right: 24,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Opacity(
                  opacity: _fadeInAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widget.displayRecipe.name}",
                          style: contentHeaderTextStyle,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "${widget.displayRecipe.description}",
                          style: contentBodyTextStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Materials",
                          style: contentSubheaderTextStyle,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        _buildMatList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
