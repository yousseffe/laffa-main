import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';

class PosterSection extends StatefulWidget {
  const PosterSection({super.key});

  @override
  _PosterSectionState createState() => _PosterSectionState();
}

class _PosterSectionState extends State<PosterSection> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return; // Avoid errors if widget is disposed
      setState(() {
        _currentPage++;
        final posters = Provider.of<DataProvider>(context, listen: false).posters;
        for (var poster in posters) {
          print(poster.imageUrl);
        }
        if (_currentPage >= (posters.length / _getImagesPerPage()).ceil()) {
          _currentPage = 0; // Reset for infinite loop
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    });
  }

  int _getImagesPerPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 600 ? 2 : 1; // Show 2 images on large screens, 1 on small screens
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int imagesPerPage = constraints.maxWidth > 600 ? 2 : 1;
        return SizedBox(
          height: 170,
          child: Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              List posters = dataProvider.posters;
              int pageCount = (posters.length / imagesPerPage).ceil();

              return PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                itemBuilder: (_, pageIndex) {
                  int startIndex = pageIndex * imagesPerPage;
                  List items = posters.sublist(
                    startIndex,
                    (startIndex + imagesPerPage).clamp(0, posters.length),
                  );

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items
                        .map((poster) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            poster.imageUrl ?? '',
                            height: 170,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    ))
                        .toList(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
