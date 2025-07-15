import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<IconData> icons;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.icons,
    required this.onTabSelected,
  }) : super(key: key);

  // _fabAlignment is not used in this version,
  // but keeping it if you plan to re-integrate a FAB later.
  Alignment _fabAlignment(int index) {
    const positions = [-1.0, -0.5, 0.0, 0.5, 1.0];
    return Alignment(positions[index], 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // Define colors for better management
    final Color selectedColor = Colors.purple[600]!; // A nice shade of purple
    const Color unselectedColor = Colors.black26;
    const Color backgroundColor = Colors.white;
    final Color shadowColor = Colors.grey.withOpacity(0.4);
    const double iconSize = 30.0;
    const double selectedIconSize = 35.0; // Slightly larger when selected

    return Container(
      // Outer container to manage margin and stack behavior better
      margin: const EdgeInsets.all(20), // Margin around the entire nav bar
      height: 90,
      width: 100,// Height of the nav bar container
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        // Consider removing the border if the shadow is prominent enough
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2,
        // ),
      ),
      child: Stack(
        // Use Stack to layer the indicator
        alignment: Alignment.center, // Center the Row of icons
        children: [
          // Row of Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(icons.length, (index) {
                final bool isSelected = currentIndex == index;
                return Expanded(
                  // Use Expanded to ensure items take equal space for indicator alignment
                  child: GestureDetector(
                    onTap: () => onTabSelected(index),
                    behavior: HitTestBehavior.opaque, // Ensures taps are registered on the whole area
                    child: Column( // Column to potentially add text labels later
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.2 : 1.0, // Scale up if selected
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Icon(
                            icons[index],
                            size: iconSize, // Base size
                            color: isSelected ? selectedColor : unselectedColor,
                          ),
                        ),
                        // You could add animated text here too
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            ['Home', 'Council', 'Concern', 'Follow Me', 'Emergency'][currentIndex], // Replace with actual labels if you have them
                            style: TextStyle(color: selectedColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // Sliding Indicator
          // This calculates the position for the indicator based on the current index
          // It assumes icons are roughly equally spaced by MainAxisAlignment.spaceAround
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutExpo, // A nice bouncy curve
            bottom: 8, // Position the indicator at the bottom of the nav bar
            left: (MediaQuery.of(context).size.width - 40 - 24) / // (Screenwidth - H_margin - H_padding)
                icons.length *
                currentIndex +
                ((MediaQuery.of(context).size.width - 40 - 24) / icons.length - 20) / 2, // Centering logic
            child: Container(
              width: 20, // Width of the indicator
              height: 5, // Height of the indicator
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }
}