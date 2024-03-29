import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:technology/Screens/product_info.dart';
import 'package:technology/models/cart.dart';
import 'package:technology/models/product.dart';

class ProductCarosel extends StatefulWidget {
  @override
  _ProductCaroselState createState() => _ProductCaroselState();
}

class _ProductCaroselState extends State<ProductCarosel> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchdata().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final dummyinfo = Provider.of<ProductsProvider>(context);
    final dummyinfocart = Provider.of<CartProvider>(context);
    final dummyinfodata = dummyinfo.dummyproducts;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Products',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8)),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 300.0,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyinfodata.length,
                  itemBuilder: (context, index) {
                    ProductModel dumprod = dummyinfodata[index];
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      width: 210.0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            bottom: 15.0,
                            child: Container(
                              height: 120.0,
                              width: 200.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ListTile(
                                    title: Text(
                                      '${dumprod.title}',
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text('\$${dumprod.price}'),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        dummyinfocart.additems(
                                            dumprod.id,
                                            dumprod.title,
                                            dumprod.price,
                                            dumprod.imgurl);
                                        Scaffold.of(context)
                                            .hideCurrentSnackBar();
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Added item to cart!',
                                            ),
                                            duration: Duration(seconds: 1),
                                            action: SnackBarAction(
                                              label: 'UNDO',
                                              textColor: Colors.red,
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.plusCircle,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0),
                              ],
                            ),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(ProductInfo.routeName,
                                            arguments: ({
                                              'id': dumprod.id,
                                              'image': dumprod.imgurl,
                                              'titlep': dumprod.title,
                                              'price': dumprod.price
                                            }));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Hero(
                                      tag: dumprod.id,
                                      child: Image(
                                        height: 180,
                                        width: 180,
                                        image: NetworkImage(dumprod.imgurl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
