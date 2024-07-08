// inicio_screen.dart

import 'package:flutter/material.dart';

class InicioPantalla extends StatefulWidget {
  const InicioPantalla({Key? key}) : super(key: key);

  @override
  InicioPantallaState createState() => InicioPantallaState();
}

class InicioPantallaState extends State<InicioPantalla> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _sections = ["Introduction", "Section 1", "Section 2", "Conclusion"];
  final List<GlobalKey> _sectionKeys = List.generate(4, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {}); // To update the sticky navbar position
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    final keyContext = _sectionKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(keyContext, duration: Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Flexible(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  title: Text('Inicio'),
                  pinned: true,
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      'https://via.placeholder.com/400',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    child: _buildStickyHeader(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    _sections.asMap().entries.map((entry) {
                      int index = entry.key;
                      String section = entry.value;
                      return _buildSection(section, index);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 250,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _sections.asMap().entries.map((entry) {
                int index = entry.key;
                String section = entry.value;
                return ListTile(
                  title: Text(section),
                  onTap: () {
                    _scrollToSection(index);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _sections.asMap().entries.map((entry) {
          int index = entry.key;
          String section = entry.value;
          return InkWell(
            onTap: () => _scrollToSection(index),
            child: Text(
              section,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(String section, int index) {
    return Container(
      key: _sectionKeys[index],
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section,
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          SizedBox(height: 16.0),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Praesent sit amet fringilla nunc, at aliquet nisi. '
            'Nullam nec felis nec quam dictum fermentum.',
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 60.0;

  @override
  double get maxExtent => 60.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
