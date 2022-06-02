import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _launchURL(String url) async {
      // const url = 'https://www.google.com/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Informações",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green[300],
      ),
      body: CustomScrollView(
        slivers: [
          !Responsive.isDesktop(context) && !Responsive.isTablet(context)
              ? SliverToBoxAdapter(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: [
                      _buildCardCarrousel('images/info.jpg', 'Crédito Pessoal'),
                      _buildCardCarrousel(
                          'images/infoPromo.jpg', 'Conta Capital'),
                      _buildCardCarrousel('images/assessoriajuridica.jpg',
                          'Assessoria Jurídica'),
                    ],
                  ),
                )
              : SliverToBoxAdapter(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            sliver: SliverGrid.count(
              crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildCardMenu(
                  'Notícias da Cooperativa',
                  Colors.blue[600],
                  Icons.file_copy,
                  Colors.blue[200],
                  () => _launchURL('https://copbayer.com.br/artigos'),
                ),
                _buildCardMenu(
                  'Assessoria Jurídica',
                  Colors.green[800],
                  Icons.work_outline,
                  Colors.greenAccent,
                  () => _launchURL(
                      'https://copbayer.com.br/para-voce#assessoria_juridica'),
                ),
                _buildCardMenu(
                  'Informações sobre Empréstimos',
                  Colors.orange,
                  Icons.attach_money,
                  Colors.orange[200],
                  () => _launchURL(
                      'https://copbayer.com.br/para-voce#credito_pessoal'),
                ),
                _buildCardMenu(
                  'Site',
                  Colors.purple[800],
                  Icons.web,
                  Colors.purple[200],
                  () => _launchURL('https://copbayer.com.br/'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildCardCarrousel(String image, String text) {
  return Container(
    margin: const EdgeInsets.all(20),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            image,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 20,
          left: 10,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCardMenu(
  String label,
  Color color,
  IconData icon,
  Color gradient,
  Function launchURL,
) {
  return InkWell(
    onTap: launchURL,
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.topLeft,
            begin: Alignment.bottomRight,
            colors: [
              color,
              gradient,
            ],
          ),
          // color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
  );
}
