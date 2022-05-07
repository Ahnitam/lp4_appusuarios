import 'package:flutter/material.dart';
import 'package:lp4_appusuarios/components/search_product_delegate.dart';
import 'package:lp4_appusuarios/provider/product_provider.dart';
import 'package:provider/provider.dart';
import '../components/details_sellingProduct_dialog.dart';
import '../components/shopping_cart_dialog.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  late ProductProvider productProvider;
  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) => productProvider.getProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos à Venda"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchProductDelegate(
                  products: productProvider.products,
                ),
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Consumer<ProductProvider>(
          builder: (BuildContext context, value, Widget? child) {
            final products = value.products;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                if (products.isNotEmpty) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailsSellingProductDialog(
                              product: product,
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: product.mainColor, width: 3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Hero(
                                  tag: "${product.id}",
                                  child: product.image.isEmpty
                                      ? const Icon(
                                          Icons.warning_rounded,
                                          color: Colors.amber,
                                          size: 50,
                                        )
                                      : SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            foregroundImage: NetworkImage(
                                              product.image,
                                            ),
                                          ),
                                        ),
                                ),
                                title: Text(
                                  product.name,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.shopping_cart),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ShoppingCartDialog(), // TODO: Falta enviar o produto a ser inserido quando navegar.
                                        fullscreenDialog: true,
                                      )
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25, top: 5, bottom: 10, right: 25),
                                child: Text(
                                  "R\$ ${product.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 30,
                                  ),
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25, top: 0, bottom: 10, right: 25),
                                child: Text(
                                  "Clique para ver detalhes",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: const Text(
                        "Nenhum Produto à venda disponível.",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
