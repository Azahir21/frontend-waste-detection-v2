import 'package:flutter/material.dart';

class PaginationButton extends StatelessWidget {
  PaginationButton(
      {Key? key,
      required this.currentPage,
      required this.totalPage,
      required this.onPrevious,
      required this.onNext})
      : super(key: key);

  final int currentPage;
  final int totalPage;
  final Future<void> Function() onPrevious;
  final Future<void> Function() onNext;

  factory PaginationButton.primary({
    Key? key,
    required int currentPage,
    required int totalPage,
    required Future<void> Function() onPrevious,
    required Future<void> Function() onNext,
    required BuildContext context,
  }) {
    return PaginationButton(
      key: key,
      currentPage: currentPage,
      totalPage: totalPage,
      onPrevious: onPrevious,
      onNext: onNext,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: currentPage > 1
              ? IconButton(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.arrow_back_ios),
                )
              : const SizedBox.shrink(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: currentPage < totalPage
              ? IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward_ios),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Align(
    //       alignment: Alignment.centerLeft,
    //       child: controller.currentPage.value > 1
    //           ? IconButton(
    //               onPressed: () => controller.getPrevPage(),
    //               icon: const Icon(Icons.arrow_back_ios),
    //             )
    //           : const SizedBox.shrink(),
    //     ),
    //     Align(
    //       alignment: Alignment.centerRight,
    //       child: controller.currentPage.value < controller.totalPage.value
    //           ? IconButton(
    //               onPressed: () => controller.getNextPage(),
    //               icon: const Icon(Icons.arrow_forward_ios),
    //             )
    //           : const SizedBox.shrink(),
    //     ),
    //   ],
    // );
  }
}
