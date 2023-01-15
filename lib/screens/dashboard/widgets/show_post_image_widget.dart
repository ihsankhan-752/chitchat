import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ShowPostImagesWidget extends StatelessWidget {
  final dynamic data;
  const ShowPostImagesWidget({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      child: Swiper(
        controller: SwiperController(),
        pagination: SwiperPagination(
            builder: FractionPaginationBuilder(
          color: Color(0xfffee715),
          activeColor: Color(0xfffee715),
          fontSize: 22,
          activeFontSize: 22,
        )),
        itemCount: data['postImages'].length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(data['postImages'][index], fit: BoxFit.cover),
              ],
            ),
          );
        },
      ),
    );
  }
}
